#!/bin/bash
sleep 10
setport () {
  LOCAL_IP=`ip -o -f inet addr show dev tun06 | awk '{ print $4 }' | cut -f 1 -d '/'`
  PORT=`cat /opt/piavpn-manual/portforward_info`
  if [[ $PORT =~ ^-?[0-9]+$ ]]
  then
    echo [set-deluge-port] Local IP=$LOCAL_IP, Port=$PORT, Client ID=setport
    deluge-console -c /app/deluge "config --set random_port False"
    deluge-console -c /app/deluge "config --set listen_ports ($PORT,$PORT)"
    deluge-console -c /app/deluge "config --set listen_interface $LOCAL_IP"
  else
    echo ERROR: Port $PORT is not an integer
    echo "DEBUG: ${DEBUG}"
  fi
}

setport

inotifywait -q -m -e close_write /opt/piavpn-manual/portforward_info |
while read events; do
  setport
done
