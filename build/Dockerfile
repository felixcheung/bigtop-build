# Docker image to build Hadoop and Big Data projects with Apache Bigtop

FROM centos:7

# Install prerequisites - jdk 8, puppet, bigtop toolchain
# And git clone bigtop source
RUN yum -y upgrade && yum -y update && yum clean all && \
    yum -y install sudo curl unzip git java-1.8.0-openjdk-devel && \
    rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm && yum -y install puppet && \
    git clone -b imagebuild https://github.com/felixcheung/bigtop.git && \
    cd bigtop && \
    ./gradlew toolchain

# Setup environment and build RPMs
# ./gradlew *-rpm command is generally restartable - it will only build if not complete/cached (unless you run ./gradlew clean)
RUN . /etc/profile.d/bigtop.sh && \
    cd bigtop && \
    ./gradlew alluxio-rpm flume-rpm hadoop-rpm hbase-rpm hive-rpm hue-rpm kafka-rpm kite-rpm && \
    ./gradlew mahout-rpm oozie-rpm phoenix-rpm pig-rpm spark-rpm sqoop-rpm sqoop2-rpm tez-rpm zeppelin-rpm zookeeper-rpm && \
    echo '*DONE*'
