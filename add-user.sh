#!/bin/bash

set -x

if [ -f /var/cache/apt/pkgcache.bin ]; then
    if (( $(date '+%s') - $(stat -c '%Y' /var/cache/apt/pkgcache.bin) > 86400 )) ; then
	apt-get update
    fi
else
    apt-get update
fi

hash curl 2>/dev/null || sudo DEBIAN_FRONTEND=noninteractive apt-get install curl -qq
hash jq 2>/dev/null || sudo DEBIAN_FRONTEND=noninteractive apt-get install jq -qq

USER=ligouras

getent passwd $USER >/dev/null || useradd -m $USER

HOME=$(getent passwd $USER | awk -F':' '{print $6}')
GROUP=$(getent passwd $USER | awk -F':' '{print $4}')
GROUP=$(getent group $GROUP | awk -F':' '{print $3}')

install -d -m 0700 -o $USER -g $GROUP $HOME/.ssh
install -m 0600 -o $USER -g $GROUP $HOME/.ssh/authorized_keys

curl https://api.github.com/users/$USER/keys | jq -r .[].key >> $HOME/.ssh/authorized_keys
