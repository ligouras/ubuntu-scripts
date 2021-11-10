#!/bin/bash

source apt-update.sh || exit 1

hash curl 2>/dev/null || apt-get install -y curl
hash jq 2>/dev/null || apt-get install -y jq

USER=${1:-user)}
GITHUB=${2:-ligouras}

getent passwd $USER >/dev/null || exit 1

HOME=$(getent passwd $USER | awk -F':' '{print $6}')
GROUP=$(getent passwd $USER | awk -F':' '{print $4}')

install -d -m 0700 -o $USER -g $GROUP $HOME/.ssh
install -m 0600 -o $USER -g $GROUP /dev/null $HOME/.ssh/authorized_keys

curl -s https://api.github.com/users/$GITHUB/keys | jq -r .[].key >> $HOME/.ssh/authorized_keys
