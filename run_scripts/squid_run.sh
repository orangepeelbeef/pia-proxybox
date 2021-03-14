#!/bin/bash
# delete pid file in case it crashed
rm /var/run/squid.pid

cp /etc/squid/squid.conf.tmpl /etc/squid/squid.conf


## setup route for local networks
DEFAULT_GATEWAY=$(ip route show default | awk '/default/ {print $3}')
if [ -z "${HOST_SUBNET}" ]; then
        echo "[warn] HOST_SUBNET not specified, deluge web interface will not work"
else
        ip route add $HOST_SUBNET via $DEFAULT_GATEWAY
fi
echo "[info] current route"
ip route
echo "--------------------"


# allow other containers in same network to access squid
INSIDE_NET=`ip -o -f inet addr show dev eth0 | awk '{ print $4 }'`


MY_SUBNET=`ipcalc $INSIDE_NET | grep Network: | awk '{print $2}'`

cat >> /etc/squid/squid.conf << EOL
# our subnet
acl my_subnet src $HOST_SUBNET
acl my_subnet src $MY_SUBNET
http_access allow my_subnet
http_access allow localhost
http_access deny all
EOL

# wait for tun06(vpn) to come up
while [[ ! `ip add sh dev tun06 | grep inet | wc -l` ]]; do
        sleep 10
done

/usr/sbin/squid -YC -f /etc/squid/squid.conf -N
