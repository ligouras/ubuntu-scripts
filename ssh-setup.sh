#!/bin/bash

[ -f apt-update.sh ] && source apt-update.sh

# install openssh

apt-get install -y openssh-client openssh-server

# harden sshd_config

sed -i /etc/ssh/sshd_config -e 's,^#\?LoginGraceTime.*$,LoginGraceTime 30,'
#sed -i /etc/ssh/sshd_config -e 's,^#\?PermitRootLogin.*$,PermitRootLogin no,'
sed -i /etc/ssh/sshd_config -e 's,^#\?PermitRootLogin.*$,PermitRootLogin without-password,'
sed -i /etc/ssh/sshd_config -e 's,^#\?PasswordAuthentication.*$,PasswordAuthentication no,'
sed -i /etc/ssh/sshd_config -e 's,^#\?AcceptEnv LANG LC_,#AcceptEnv LANG LC_,'

# install fail2ban

apt-get install -y fail2ban

service fail2ban restart

fail2ban-client status sshd

#cat <<EOF > /etc/fail2ban/jail.local
#
#[DEFAULT]
#ignoreip = 127.0.0.1/8 ::1
#bantime = 3600
#findtime = 600
#maxretry = 5
#
#[sshd]
#enabled = true
#EOF
