#!/bin/bash

SERVER_FQDN=$1

if [[ -z $SERVER_FQDN ]]; then
  ambari-server start &
else
  ambari-agent reset $SERVER_FQDN
fi

ambari-agent start &

/usr/sbin/sshd -D
