# A collection of proxy tools via Private Internet Access.

An [Ubuntu](https://ubuntu.org/) Linux container running:
 1. socks5 proxy (using [dante](https://www.inet.no/dante/))
 2. http proxy (using [squid](https://www.squid.org/))
 3. Torrents ( using [deluge](https://www.deluge.org/))

all via Private Internet Access (OpenVPN).

Protect your browsing activities through an encrypted and anonymized VPN proxy!

You will need a [PrivateInternetAccess](https://www.privateinternetaccess.com/pages/how-it-works) account.
If you don't have one, you can [sign up here](https://www.privateinternetaccess.com/pages/buy-vpn) for one.

## Starting the VPN Proxy

```sh
docker run -d \
--cap-add=NET_ADMIN \
--device=/dev/net/tun \
--dns=127.0.0.1 \
--name=pia-proxyboxng \
--restart=always \
-e "PIA_USER=<pia_username>" \
-e "PIA_PASS=<pia_password>" \
-e "REGION_ID=<pia ng region>" \
-e "DELUGE_UID=1000" \
-e "DELUGE_GID=1000" \
-e "HOST_SUBNET=<host subnet eg: 192.168.0.0/24>" \
-v /location/to/torrents:/torrents \
-v /location/to/app/deluge:/app/deluge \
-v /etc/localtime:/etc/localtime:ro \
-p 1080:1080 \
-p 8112:8112 \
-p 3128:3128
orangepeelbeef/pia-proxyboxng
```

Substitute the environment variables for `REGION_ID`, `PIA_USER`, `PIA_PASS` as indicated.

A `docker-compose-dist.yml` file has also been provided. Copy this file to `docker-compose.yml` and substitute the environment variables are indicated.

Then start the VPN Proxy via:

```sh
docker-compose up -d
```

### Environment Variables

`REGION_ID` - DNS to the PIA server in desired region eg: ro 

See the serverlist filtered with port forwarding support
eg: curl -s https://serverlist.piaservers.net/vpninfo/servers/v4 | head -1 | jq -r '.regions[] | select(.port_forward==true) | .id '
 
`PIA_USER` / `PIA_PASS` - Credentials to connect to PIA

## Connecting to the VPN Proxy

To connect to the VPN Proxy, set your browser socks5 proxy to localhost:1080.

## CREDITS
https://github.com/pia-foss/manual-connections
