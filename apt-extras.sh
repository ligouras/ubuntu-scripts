#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

hash add-apt-repository 2>/dev/null
if [ $\? -ne 0 ]; then
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common
fi
