FROM centos:6.7

EXPOSE 22 1024-65534

# Platform and SSH stuff.
RUN yum install -y \
    openssh-server \
    postgresql-server \
    tar \
    wget \
    which \
    yum-utils

ADD tini /tini
ADD authorized_keys /root/.ssh/authorized_keys

RUN /usr/bin/ssh-keygen -f /etc/ssh/ssh_host_rsa_key -b 2048 -N '' -t rsa && \
    /usr/bin/ssh-keygen -f /etc/ssh/ssh_host_dsa_key -b 1024 -N '' -t dsa && \
    chmod 444 /root/.ssh/authorized_keys

# Install Ambari.
RUN wget -O /etc/yum.repos.d/bigtop.repo http://archive.apache.org/dist/bigtop/bigtop-1.1.0/repos/centos6/bigtop.repo && \
    echo "gpgcheck=0" >> /etc/yum.conf && \
    yum-config-manager --add-repo http://sparkpreviewrelease.blob.core.windows.net/rel/bigtop-build-el6-repo && \
    yum install ambari-server ambari-agent -y && \
    ambari-server setup -s
    
ADD start.sh /tmp/start.sh

ENTRYPOINT ["/tini", "-g", "--", "/tmp/start.sh"]