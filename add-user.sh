#!/bin/bash

USER=${1:-user)}
PASS=${2}

useradd -m -s /bin/bash $USER
[ -z "$PASS" ] || echo "$USER:$PASS" | chpasswd

getent passwd $USER
