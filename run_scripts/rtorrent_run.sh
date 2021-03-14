#!/bin/bash
#sanity check uid/gid
  if [ $RTORRENT_UID -ne 0 -o $RTORRENT_UID -eq 0 2>/dev/null ]; then
        if [ $RTORRENT_UID -lt 100 -o $RTORRENT_UID -gt 65535 ]; then
        echo "[warn] RTORRENT_UID out of (100..65535) range, using default of 500"
      RTORRENT_UID=500
    fi
  else
    echo "[warn] RTORRENT_UID non-integer detected, using default of 500"
    RTORRENT_UID=500
        fi

        if [ $RTORRENT_GID -ne 0 -o $RTORRENT_GID -eq 0 2>/dev/null ]; then
          if [ $RTORRENT_GID -lt 100 -o $RTORRENT_GID -gt 65535 ]; then
             echo "[warn] RTORRENT_GID out of (100..65535) range, using default of 500"
             RTORRENT_GID=500
          fi
        else
          echo "[warn] RTORRENT_GID non-integer detected, using default of 500"
          RTORRENT_GID=500
        fi

        # add UID/GID or use existing
grep -qw ^torrents /etc/group || addgroup --gid $RTORRENT_GID torrents
grep -qw ^torrents /etc/passwd || adduser --ingroup torrents --disabled-password --gecos '' -u $RTORRENT_UID torrents 

if [! -d /app/rtorrent ]; then
  mkdir -p /app/rtorrent
fi
  
if [! -f /app/rtorrent/rtorrent.rc]; then
   cp /tmp/rtorrent.rc.tmpl /app/rtorrent/rtorrent.rc
fi

chown -R torrents:torrents /app
su torrents -c "/usr/bin/screen -dmfa -S rtorrent /usr/bin/rtorrent -n -o import=/app/rtorrent"
