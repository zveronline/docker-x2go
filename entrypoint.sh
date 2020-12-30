#!/bin/bash
set -e

set_user_passwd() {
  echo "zveronline:$USER_PASSWORD" | chpasswd
}

set_user_passwd

if [ ! -f /etc/ssh/ssh_host_rsa_key ]
then
  ssh-keygen -A
fi

cp /config/host/sshd_config /etc/ssh/

exec "$@"
