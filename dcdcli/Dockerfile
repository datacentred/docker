FROM node:slim
MAINTAINER "nick@datacentred.co.uk"

RUN apt-get update && apt-get -y dist-upgrade \
 && apt-get install -y git build-essential figlet \
    linux-headers-amd64 python-dev python-setuptools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && easy_install pip \
 && pip install pytz python-openstackclient \
 && rm -rf ~/.cache \
 && mkdir /app \
 && git clone https://github.com/krishnasrinivas/wetty /app/wetty \
 && cd /app/wetty \
 && npm install

RUN useradd -c "DataCentred" -d /home/datacentred -m \
    -p '$1$Nikoyhym$jfDUeZZ47eL6iLkmnqBWS.' -s `which bash` datacentred \
    && echo 'datacentred' | figlet > /etc/motd

ADD stackrc.sh /home/datacentred/.profile

EXPOSE 8000
CMD node /app/wetty/app.js -p 8000

# vim:ts=4:sw=4:et:ft=Dockerfile
