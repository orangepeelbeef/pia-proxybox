#!/bin/bash
docker pull alpine:latest
docker build . -t orangepeelbeef/pia-proxybox:dev --no-cache
docker push orangepeelbeef/pia-proxybox:dev
