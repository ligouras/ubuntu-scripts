#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /var/cache/apt/pkgcache.bin ]; then
    if (( $(date '+%s') - $(stat -c '%Y' /var/cache/apt/pkgcache.bin) > 86400 )) ; then
	    apt-get update -y
    fi
else
    apt-get update -y
fi
