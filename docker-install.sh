#!/bin/bash

if [ -f /var/cache/apt/pkgcache.bin ]; then
    if (( $(date '+%s') - $(stat -c '%Y' /var/cache/apt/pkgcache.bin) > 86400 )) ; then
	sudo apt-get update
    fi
else
    sudo apt-get update
fi

# dependencies

hash add-apt-repository 2>/dev/null
if [ $? -ne 0 ]; then
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common
fi

# uninstall older versions of Docker

sudo apt-get remove docker docker-engine docker.io containerd runc

# docker repository

if [ $(sudo apt-key fingerprint 0EBFCD88 | wc -l) -eq 0 ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
fi

if [ $(find /etc/apt/ -name *.list | xargs cat | grep ^[[:space:]]*deb | grep download.docker.com | wc -l) -eq 0 ]; then
    sudo add-apt-repository -y \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
fi

# docker

hash dockerd 2>/dev/null
if [ $? -ne 0 ]; then
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
fi

# docker-compose

DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)"

[ -f /usr/local/bin/docker-compose ] || sudo curl -qL ${DOCKER_COMPOSE_URL} -o /usr/local/bin/docker-compose
[ -x /usr/local/bin/docker-compose ] || sudo chmod +x /usr/local/bin/docker-compose
