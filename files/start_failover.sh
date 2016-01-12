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

if [ -n "$SERVICE_PORT" ]; then
cat>/etc/keepalived/keepalived.conf<<EOF
vrrp_script chk_haproxy {
  script "</dev/tcp/${SERVICE_IP}/${SERVICE_PORT}"
  interval 2
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
    chk_haproxy
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

keepalived --dont-fork --log-console
