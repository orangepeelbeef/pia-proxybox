#!/bin/bash
if [[ -z $1 ]]; then
  echo "Usage: $0 tagtobuild\nex: $0 dev"
  exit 1
fi
echo $1
docker pull ubuntu:20.04 
docker build . -t orangepeelbeef/pia-proxyboxng:$1 --no-cache
#docker push orangepeelbeef/pia-proxyboxng:$1
