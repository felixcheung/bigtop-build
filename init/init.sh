#!/bin/bash

# This script should be run on the machine with the RPM packages installed.

# run as sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

# namenode, yarn
/etc/init.d/hadoop-hdfs-namenode init
for i in hadoop-hdfs-namenode hadoop-hdfs-datanode ; do sudo service $i start ; done
sudo -u hdfs hadoop fs -mkdir -p /user/$USER
sudo -u hdfs hadoop fs -chown $USER:$USER /user/$USER
sudo -u hdfs hadoop fs -chmod 770 /user/$USER
sudo -u hdfs hadoop fs -mkdir /tmp
sudo -u hdfs hadoop fs -chmod -R 1777 /tmp
sudo -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn
sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn
sudo -u hdfs hadoop fs -mkdir -p /user/history
sudo -u hdfs hadoop fs -chown mapred:mapred /user/history
sudo -u hdfs hadoop fs -chmod 770 /user/history
sudo -u hdfs hadoop fs -mkdir -p /tmp/hadoop-yarn/staging
sudo -u hdfs hadoop fs -chmod -R 1777 /tmp/hadoop-yarn/staging
sudo -u hdfs hadoop fs -mkdir -p /tmp/hadoop-yarn/staging/history/done_intermediate
sudo -u hdfs hadoop fs -chmod -R 1777 /tmp/hadoop-yarn/staging/history/done_intermediate
sudo -u hdfs hadoop fs -chown -R mapred:mapred /tmp/hadoop-yarn/staging
sudo service hadoop-yarn-resourcemanager start
sudo service hadoop-yarn-nodemanager start

# hive
sudo -u hdfs hadoop fs -mkdir /tmp
sudo -u hdfs hadoop fs -mkdir -p /user/hive/warehouse
sudo -u hdfs hadoop fs -chmod g+x /tmp
sudo -u hdfs hadoop fs -chmod g+x /user/hive/warehouse
sudo /etc/init.d/hive-server2 start

# spark
# For Spark, HiveContext/SparkSession(HiveSupportEnabled) to work with Hive Metastore to read Hive tables
cp /etc/hive/conf/hive-site.xml /etc/spark/conf/
