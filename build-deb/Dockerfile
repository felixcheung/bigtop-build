# Docker image to build Hadoop and Big Data projects with Apache Bigtop

FROM ubuntu:16.04
 
# Install prerequisites - jdk 8, puppet, puppetlabs-apt, bigtop toolchain
# And git clone bigtop source
# lsb-release is required for puppetlabs-apt, puppetlabs-apt is required to get puppet in toolchain to work
RUN apt-get -y update && apt-get -y upgrade && apt-get -y clean && \
    apt-get install --no-install-recommends -y curl wget sudo unzip git lsb-release && \
    apt-get install --no-install-recommends -y libssl-dev openjdk-8-jdk xmlto && \
    wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb && \
    dpkg -i puppetlabs-release-pc1-xenial.deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y puppet && \
    puppet module install puppetlabs-apt && \
    # preinstalling packages since bigtop toolchain fails to install it
    apt-get install --no-install-recommends -y asciidoc && \
    git clone -b imagebuild2 https://github.com/felixcheung/bigtop.git && \
    cd bigtop && \
    ./gradlew toolchain

# Setup environment and build Debs
# Debs will be under /bigtop/output/{project}
# Remove for now as they don't work: hue-deb 
RUN . /etc/profile.d/bigtop.sh && \
    cd bigtop && \
    ./gradlew alluxio-deb flume-deb hadoop-deb hbase-deb hive-deb kafka-deb kite-deb && \
    ./gradlew mahout-deb oozie-deb phoenix-deb pig-deb spark-deb sqoop-deb sqoop2-deb tez-deb zeppelin-deb zookeeper-deb && \
    echo '*Bigtop DONE*'

# Setup environment and build Debs
# Debs will be under /bigtop/output/ambari
RUN . /etc/profile.d/bigtop.sh && \
    cd bigtop && \
    ./gradlew ambari-deb && \
    echo '*Ambari DONE*'
