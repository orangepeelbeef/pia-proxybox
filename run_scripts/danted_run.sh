#!/bin/bash

cp /etc/danted.conf.tmpl /etc/danted.conf


## setup client pass for local networks
if [ -z "${HOST_SUBNET}" ]; then
        echo "[warn] HOST_SUBNET not specified, dante interface will not work"
else

# get local container network for dante acl 
INSIDE_NET=`ip -o -f inet addr show dev eth0 | awk '{ print $4 }'`
MY_SUBNET=`ipcalc $INSIDE_NET | grep Network: | awk '{print $2}'`


cat >> /etc/danted.conf << EOL

#allow connections from local network 
client pass {
        from: $HOST_SUBNET to: 0.0.0.0/0
        log: error # connect disconnect
}

#allow connections from local container net 
client pass {
        from: $MY_SUBNET to: 0.0.0.0/0
        log: error # connect disconnect
}

EOL

fi

# wait for tun06(vpn) to come up
while [[ ! `ip add sh dev tun06 | grep inet | wc -l` ]]; do
        sleep 10
done

/usr/sbin/danted
