#!/bin/bash
docker pull alpine:latest
docker build . -t orangepeelbeef/pia-proxybox:latest
docker push orangepeelbeef/pia-proxybox:latest