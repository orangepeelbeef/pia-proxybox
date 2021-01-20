#!/bin/bash
docker pull Ubuntu:18.04 
docker build . -t orangepeelbeef/pia-proxyboxng:dev --no-cache
docker push orangepeelbeef/pia-proxyboxng:dev
