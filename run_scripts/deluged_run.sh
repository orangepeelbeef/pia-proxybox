#!/bin/bash
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

su torrents -c "/usr/bin/deluged -c /app/deluge -d --loglevel=info -l /app/deluge/deluged.log"
