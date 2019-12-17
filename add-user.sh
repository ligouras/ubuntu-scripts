#!/bin/bash

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

if [ "$(id -un)" != "$USER" ]; then
	sudo -Hu $USER $0 $@
else
	install -d -m 0700 $HOME/.ssh
	install -m 0600 $HOME/.ssh/authorized_keys

	curl https://api.github.com/users/$USER/keys | jq -r .[].key >> $HOME/.ssh/authorized_keys
fi
