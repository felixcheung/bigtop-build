FROM centos:6

EXPOSE 22 1024-65534

ADD authorized_keys /root/.ssh/authorized_keys
ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

# Platform and SSH stuff.
RUN yum install -y \
      openssh-clients \
      openssh-server \
      postgresql-server \
      sudo \
      tar \
      wget \
      which \
      yum-utils && \
    /usr/bin/ssh-keygen -f /etc/ssh/ssh_host_rsa_key -b 2048 -N '' -t rsa && \
    /usr/bin/ssh-keygen -f /etc/ssh/ssh_host_dsa_key -b 1024 -N '' -t dsa && \
    chmod 444 /root/.ssh/authorized_keys && \
    chmod +x /tini

# Install Ambari.
RUN wget -O /etc/yum.repos.d/bigtop.repo http://archive.apache.org/dist/bigtop/bigtop-1.1.0/repos/centos6/bigtop.repo && \
    echo "gpgcheck=0" >> /etc/yum.conf && \
    yum-config-manager --add-repo http://sparkpreviewrelease.blob.core.windows.net/rel/bigtop-build-el6-repo && \
    yum install ambari-server ambari-agent -y && \
    ambari-server setup -s && \
    echo 'javas=(/usr/jdk64/*)' >> /etc/profile.d/java.sh && \
    echo 'export JAVA_HOME=${javas[@]: -1}' >> /etc/profile.d/java.sh

ADD start-node.sh /tmp/start-node.sh

# Uncomment to test local changes.
#ADD services /var/lib/ambari-server/resources/stacks/BIGTOP/1.0/services
#ADD services /var/lib/ambari-agent/cache/stacks/BIGTOP/1.0/services

ENTRYPOINT ["/tini", "-g", "--", "/tmp/start-node.sh"]
