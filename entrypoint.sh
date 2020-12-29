#!/bin/bash
set -e

if [ ! -f /etc/ssh/ssh_host_rsa_key ]
then
  ssh-keygen -A
fi

cp /config/host/sshd_config /etc/ssh/

exec "$@"
