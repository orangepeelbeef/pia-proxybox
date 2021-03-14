#!/bin/bash
# wait for tun06(vpn) to come up
while [[ ! `ip add sh dev tun06 | grep inet | wc -l` ]]; do
        sleep 10
done
exec su torrents -c "/usr/bin/deluge-web -d -c /app/deluge --loglevel=error"
