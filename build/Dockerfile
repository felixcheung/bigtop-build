# Docker image to build Hadoop and Big Data projects with Apache Bigtop

# Python 2.6 in CentOS 6 required for Ambari build
FROM centos:6

# Install prerequisites - jdk 8, puppet, bigtop toolchain
# And git clone bigtop source
RUN yum -y upgrade && yum -y update && yum clean all && \
    yum -y install sudo curl unzip git java-1.8.0-openjdk-devel && \
    # puppet, note el-6
    rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm && yum -y install puppet && \
    git clone -b imagebuild https://github.com/felixcheung/bigtop.git && \
    cd bigtop && \
    ./gradlew toolchain

# Setup environment and build RPMs
# ./gradlew *-rpm command is generally restartable - it will only build if not complete/cached (unless you run ./gradlew clean)
RUN . /etc/profile.d/bigtop.sh && \
    cd bigtop && \
    ./gradlew alluxio-rpm flume-rpm hadoop-rpm hbase-rpm hive-rpm hue-rpm kafka-rpm kite-rpm && \
    ./gradlew mahout-rpm oozie-rpm phoenix-rpm pig-rpm spark-rpm sqoop-rpm sqoop2-rpm tez-rpm zeppelin-rpm zookeeper-rpm && \
    echo '*Bigtop DONE*'

# Build Ambari RPMs
RUN . /etc/profile.d/bigtop.sh && \
    mkdir src && cd src && \
    git clone -b trunks2 https://github.com/felixcheung/ambari.git && \
    export _JAVA_OPTIONS="-Xmx2048m -XX:MaxPermSize=512m -Djava.awt.headless=true" && \
    cd ambari && \
    mvn versions:set -DnewVersion=2.4.2.0.0 && \
    pushd ambari-metrics && \
    mvn versions:set -DnewVersion=2.4.2.0.0 && \
    popd && \
    mvn -B clean install package rpm:rpm -DnewVersion=2.4.2.0.0 -Dstack.distribution=BIGTOP/1.0 -DskipTests -Drat.skip -Dpython.ver="python >= 2.6" && \
    echo '*Ambari DONE*'
