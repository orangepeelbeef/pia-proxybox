FROM ubuntu:20.04
MAINTAINER "OJ LaBoeuf <orangepeelbeef@gmail.com>"

COPY openvpn_manual /openvpn_manual
COPY run_scripts /run_scripts

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update --quiet && \
 apt-get install -y software-properties-common && \
 add-apt-repository ppa:deluge-team/stable && \
 apt-get update --quiet && \
 apt-get install -y supervisor squid dante-server deluged deluge-web deluge-console openvpn curl jq git python3-pip ipcalc inotify-tools && \
 apt-get upgrade --quiet --allow-downgrades --allow-remove-essential --allow-change-held-packages -y && \
 pip3 install git+https://github.com/coderanger/supervisor-stdout && \
 apt-get remove build-essential -y && \
 apt-get autoremove -y && \
 apt-get clean --quiet && \
 rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
 mkdir -p /var/log/supervisor

COPY conf/danted.conf /etc/danted.conf.tmpl
COPY conf/squid.conf /etc/squid/squid.conf.tmpl
COPY conf/supervisord.conf /etc/supervisor/supervisord.conf
COPY conf/deluge*.conf /tmp/

ENTRYPOINT ["/usr/bin/supervisord"]
