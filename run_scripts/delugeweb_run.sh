#!/bin/bash
exec su torrents -c "/usr/bin/deluge-web -c /app/deluge --loglevel=error"
