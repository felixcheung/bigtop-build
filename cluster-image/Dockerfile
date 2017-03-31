FROM ubuntu:16.04

ADD authorized_keys /root/.ssh/authorized_keys
ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

# Platform and SSH stuff.
RUN apt-get update && \
    apt-get install -y \
      software-properties-common \
      openssh-client \
      openssh-server \
      postgresql \
      sudo \
      vim \
      tar \
      wget && \
    mkdir /var/run/sshd && \
    chmod 444 /root/.ssh/authorized_keys && \
    chmod +x /tini

ENV AMBARI_REPO_URL http://hdiapt.blob.core.windows.net/ambari-76186

# Install Ambari.
RUN apt-key adv --fetch-keys "$AMBARI_REPO_URL/conf/gpg.key" && \
    apt-key adv --fetch-keys "http://www-us.apache.org/dist/bigtop/bigtop-1.0.0/repos/GPG-KEY-bigtop" && \
    add-apt-repository "deb ${AMBARI_REPO_URL} bigtop contrib" && \
    add-apt-repository "deb http://bigtop-repos.s3.amazonaws.com/releases/1.0.0/debian/8/x86_64 bigtop contrib" && \
    apt-get update && \
    apt-get install -y ambari-server ambari-agent && \
    ambari-server setup -s && \
    echo 'javas=(/usr/jdk64/*)' >> /etc/profile.d/java.sh && \
    echo 'export JAVA_HOME=${javas[@]: -1}' >> /etc/profile.d/java.sh

# Preinstall packages to make Ambari cluster setup faster.
ENV BIGTOP_REPO_URL http://hdiapt.blob.core.windows.net/bigtop-76210

RUN apt-key adv --fetch-keys "$BIGTOP_REPO_URL/conf/gpg.key" && \
    add-apt-repository "deb ${BIGTOP_REPO_URL} bigtop contrib" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      hadoop \
      hadoop-client \
      hadoop-hdfs \
      hadoop-mapreduce \
      hadoop-yarn \
      spark-core \
      zookeeper=3.4.6-1

ADD start-node.sh /tmp/start-node.sh

ENV STACK_REPO_URL http://hdiapt.blob.core.windows.net/ambari-stack-77801

# Comment to test local changes.
RUN apt-key adv --fetch-keys "$STACK_REPO_URL/conf/gpg.key" && \
    add-apt-repository "deb ${STACK_REPO_URL} bigtop contrib" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      ambari-wildfire-stack

# Uncomment to test local changes.
#ADD stack /var/lib/ambari-server/resources/stacks/BIGTOP/1.0
#ADD stack /var/lib/ambari-agent/cache/stacks/BIGTOP/1.0

EXPOSE 22 4040 4041 8080 8088 18080

ENTRYPOINT ["/tini", "-g", "--", "/tmp/start-node.sh"]
