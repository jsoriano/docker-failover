Keepalived
==============
A simple keepalived container to provide a VIP on docker containers.

###Running

`docker run -d --name failover --net=host --privileged -e VIRTUAL_IP=<ip> -e VIRTUAL_ROUTER_ID=<vrid> --cap-add=NET_ADMIN <docker id>`

####environment:

`VIRTUAL_IP`: virtual IP address. required

`VIRTUAL_ROUTER_ID`: virtual router ID, required, it must be unique in your network

`INSTANCE_PRIORITY`: must be an integer value (101, 100, ...). Default: 100.

`SERVICE_IP`: Default: 127.0.0.1, used for health checks

`SERVICE_PORT`: Required for health checks

`INTERFACE`: Default: eth0

`INSTANCE_STATE`: Default: BACKUP
