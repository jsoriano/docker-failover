#!/bin/bash

function check_param() {
	local name=$1
	local value=$2

	if [ -z "$value" ]; then
		echo $name is needed
		exit 1
	fi
}

check_param VIRTUAL_IP $VIRTUAL_IP
check_param VIRTUAL_ROUTER_ID $VIRTUAL_ROUTER_ID

SERVICE_IP=${SERVICE_IP:-127.0.0.1}
INTERFACE=${INTERFACE:-eth0}
STATE=${INSTANCE_STATE:-BACKUP}
PRIORITY=${INSTANCE_PRIORITY:-100}
CHECK_INTERVAL=${CHECK_INTERVAL:-2}
CHECK_TIMEOUT=${CHECK_TIMEOUT:-2}
CHECK_RISE=${CHECK_RISE:-15}

if [ -n "$SERVICE_PORT" ]; then
cat>/etc/keepalived/keepalived.conf<<EOF
vrrp_script chk_service {
  script "nc -z ${SERVICE_IP} ${SERVICE_PORT}"
  # script "</dev/tcp/${SERVICE_IP}/${SERVICE_PORT}"
  interval ${CHECK_INTERVAL}
  timeout ${CHECK_TIMEOUT}
  rise ${CHECK_RISE}
  weight 50
}

vrrp_instance VI_1 {
  interface ${INTERFACE}
  state ${STATE}
  virtual_router_id ${VIRTUAL_ROUTER_ID}
  priority ${PRIORITY}
  virtual_ipaddress {
    ${VIRTUAL_IP}
  }
  track_script {
    chk_service
  }
}
EOF
else
cat>/etc/keepalived/keepalived.conf<<EOF
vrrp_instance VI_1 {
  interface ${INTERFACE}
  state ${STATE}
  virtual_router_id ${VIRTUAL_ROUTER_ID}
  priority ${PRIORITY}
  virtual_ipaddress {
    ${VIRTUAL_IP}
  }
}
EOF
fi

# Init failover config

exec keepalived --dont-fork --log-console
