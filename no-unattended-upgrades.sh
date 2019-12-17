#!/bin/bash

apt-get -y purge unattended-upgrades update-notifier-common
rm -rf /var/log/unattended-upgrades

systemctl stop apt-daily.service
systemctl stop apt-daily.timer
systemctl stop apt-daily-upgrade.service
systemctl stop apt-daily-upgrade.timer

systemctl disable apt-daily.service
systemctl disable apt-daily.timer
systemctl disable apt-daily-upgrade.service
systemctl disable apt-daily-upgrade.timer

sed -i -e 's,^exec /usr/lib/apt/apt.systemd.daily,#&,' /etc/cron.daily/apt-compat
