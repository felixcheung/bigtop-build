#!/bin/bash

# run as sudo
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

# add yum packages as a local repo
yum -y install yum-utils createrepo
createrepo /home/adminuser/yum/
echo "gpgcheck=0" >> /etc/yum.conf
yum-config-manager --add-repo file:///home/adminuser/yum

# add bigtop release as a repo to get bigtop-utils
wget -O /etc/yum.repos.d/bigtop.repo http://archive.apache.org/dist/bigtop/bigtop-1.1.0/repos/centos7/bigtop.repo

# install
yum install hadoop* spark* hbase* hue* zookeeper* pig* oozie* kafka*

# hive-hbase conflicts with hive
#  file /usr/lib/hive/lib/hive-hbase-handler-1.2.1.jar from install of hive-hbase-1.2.1-1.el7.centos.noarch conflicts with file from package hive-1.2.1-1.el7.centos.noarch
yum install hive-server2* hive-metastore* hive-hcatalog* tez*

# zeppelin has osgi dependencies and not working (yet)
