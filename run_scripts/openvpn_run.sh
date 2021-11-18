#!/bin/bash
cd /openvpn_manual/
REGIONDATA=`curl -s https://serverlist.piaservers.net/vpninfo/servers/v4 | head -1 | jq --arg REGION_ID ${REGION_ID} -r '.regions[] | select(.id==$REGION_ID)'`

META_HOSTNAME=`echo $REGIONDATA | jq -r '.servers.meta[0].cn'`
META_IP=`echo $REGIONDATA | jq -r '.servers.meta[0].ip'`
OU_HOSTNAME=`echo $REGIONDATA | jq -r '.servers.ovpnudp[0].cn'`
OU_IP=`echo $REGIONDATA | jq -r '.servers.ovpnudp[0].ip'`

generateTokenResponse=$(curl -s -u "$PIA_USER:$PIA_PASS" \
  "https://www.privateinternetaccess.com/gtoken/generateToken")

echo "$generateTokenResponse"

if [ "$(echo "$generateTokenResponse" | jq -r '.status')" != "OK" ]; then
  echo "Could not get a token. Please check your account credentials."
  echo
  echo "You can also try debugging by manually running the curl command:"
  echo $ curl -vs -u \"$PIA_USER:$PIA_PASS\" --cacert ca.rsa.4096.crt \
    --connect-to \"$bestServer_meta_hostname::$bestServer_meta_IP:\" \
    https://$bestServer_meta_hostname/authv3/generateToken
  exit 1
fi

token="$(echo "$generateTokenResponse" | jq -r '.token')"
echo "This token will expire in 24 hours."

PIA_PF=true PIA_TOKEN="$token" \
  OVPN_SERVER_IP="$OU_IP" \
  OVPN_HOSTNAME="$OU_HOSTNAME" \
  CONNECTION_SETTINGS="openvpn_udp_strong" \
  ./connect_to_openvpn_with_token.sh
