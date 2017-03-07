#!/bin/bash

# This script sets up a local repo on the RPM packages built and installs them.

# run as sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

if [ $# -ne 1 ]; then
  echo $0: usage: install.sh fullpathtoyumlocalrepo
  exit 1
fi

localrepopath=$1

# add yum packages as a local repo
yum -y install yum-utils createrepo
createrepo $localrepopath
echo "gpgcheck=0" >> /etc/yum.conf
yum-config-manager --add-repo file://$localrepopath

# add bigtop release as a repo to get bigtop-utils
wget -O /etc/yum.repos.d/bigtop.repo http://archive.apache.org/dist/bigtop/bigtop-1.1.0/repos/centos6/bigtop.repo

# install
yum install hadoop* spark* hbase* hue* zookeeper* pig* oozie* kafka* mahout*

# hive-hbase conflicts with hive
#  file /usr/lib/hive/lib/hive-hbase-handler-1.2.1.jar from install of hive-hbase-1.2.1-1.el7.centos.noarch conflicts with file from package hive-1.2.1-1.el7.centos.noarch
yum install hive-server2* hive-metastore* hive-hcatalog* tez*

# zeppelin has osgi dependencies and not working (yet)
