#!/bin/bash
sleep 10
exec su torrents -c "/usr/bin/deluge-web -d -c /app/deluge --loglevel=error"
