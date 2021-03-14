#!/bin/bash
inotifywait -q -m -e close_write /opt/piavpn-manual/portforward_info |
while read events; do
  LOCAL_IP=`ip -o -f inet addr show dev tun06 | awk '{ print $4 }' | cut -f 1 -d '/'`
  PORT=`cat /opt/piavpn-manual/portforward_info`
  if [[ $PORT =~ ^-?[0-9]+$ ]]
  then
    echo [set-rtorrent-port] Local IP=$LOCAL_IP, Port=$PORT, Client ID=setport
    #edit rtorrent.rc to set new port and kill rtorrent
    sed -i "s/network\.port_range\.set.*/network.port_range.set = ${PORT}-${PORT}/g" rtorrent.rc
    killall -w -s 2 /usr/bin/rtorrent  
  else
    echo ERROR: Port $PORT is not an integer
    echo "DEBUG: ${DEBUG}"
  fi
done
