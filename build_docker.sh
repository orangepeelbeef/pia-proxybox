#!/bin/bash
docker pull alpine:latest
docker build . -t orangepeelbeef/pia-proxybox:latest --no-cache
docker push orangepeelbeef/pia-proxybox:latest
