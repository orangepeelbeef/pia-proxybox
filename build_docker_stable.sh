#!/bin/bash
docker pull ubuntu:20.04
docker build . -t orangepeelbeef/pia-proxyboxng:latest -t orangepeelbeef/pia-proxyboxng:stable --no-cache
docker push orangepeelbeef/pia-proxyboxng:latest
docker push orangepeelbeef/pia-proxyboxng:stable
