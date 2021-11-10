#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

packages=(
    "ca-certificates"
    "apt-transport-https"
    "software-properties-common"
    "curl"
    "gnupg"
    "gnupg-agent"
    "lsb-release"
)

for p in ${packages[@]}; do
    if ! dpkg -s $p > /dev/null 2>&1; then
      sudo apt-get install -y $p
    fi
done
