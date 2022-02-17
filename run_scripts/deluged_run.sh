#!/bin/bash
w
#sanity check uid/gid
  if [ $DELUGE_UID -ne 0 -o $DELUGE_UID -eq 0 2>/dev/null ]; then
        if [ $DELUGE_UID -lt 100 -o $DELUGE_UID -gt 65535 ]; then
        echo "[warn] DELUGE_UID out of (100..65535) range, using default of 500"
      DELUGE_UID=500
    fi
  else
    echo "[warn] DELUGE_UID non-integer detected, using default of 500"
    DELUGE_UID=500
        fi

        if [ $DELUGE_GID -ne 0 -o $DELUGE_GID -eq 0 2>/dev/null ]; then
          if [ $DELUGE_GID -lt 100 -o $DELUGE_GID -gt 65535 ]; then
             echo "[warn] DELUGE_GID out of (100..65535) range, using default of 500"
             DELUGE_GID=500
          fi
        else
          echo "[warn] DELUGE_GID non-integer detected, using default of 500"
          DELUGE_GID=500
        fi

        # add UID/GID or use existing
  grep -qw ^torrents /etc/group || addgroup --gid $DELUGE_GID torrents
  grep -qw ^torrents /etc/passwd || adduser --ingroup torrents --disabled-password -gecos '' -u $DELUGE_UID torrents 

  if [[ ! -f /app/deluge/.skipsetup ]]; then
    cp /tmp/deluge-core.conf /app/deluge/core.conf
    cp /tmp/deluge-label.conf /app/deluge/label.conf
    chown -R torrents:torrents /app/deluge
    chown -R torrents:torrents /torrents
    chown -R torrents:torrents /complete
    chown -R torrents:torrents /torrentblackhole
    touch /app/deluge/.skipsetup
  fi

  # install ltconfig plugin to allow for tweaking libtorrent settings
  if [[ ! -f /app/deluge/plugins/ltConfig-2.0.0.egg ]]; then
    curl -L https://github.com/ratanakvlun/deluge-ltconfig/releases/download/v2.0.0/ltConfig-2.0.0.egg --output /app/deluge/plugins/ltConfig-2.0.0.egg
  fi

  # wait for tun06(vpn) to come up
  while [[ ! `ip add sh dev tun06 | grep inet | wc -l` ]]; do
        sleep 10
  done

  su torrents -c "/usr/bin/deluged -c /app/deluge -d --loglevel=info"
