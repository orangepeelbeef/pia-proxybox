#!/bin/bash
# kill openvpn
cat /opt/piavpn-manual/pia_pid | xargs kill -9

# kill connect script
ps -ef | grep connect_to_openvpn | grep -v grep | awk '{print $2}' | xargs kill -9

# kill port_forwarding script
ps -ef | grep port_forwarding | grep -v grep | awk '{print $2}' | xargs kill -9

