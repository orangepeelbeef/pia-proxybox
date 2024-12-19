#!/bin/bash
docker pull ubuntu:20.04 
docker build . -t orangepeelbeef/pia-proxyboxng:dev --no-cache
docker push orangepeelbeef/pia-proxyboxng:dev
