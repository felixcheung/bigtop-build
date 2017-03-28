# Docker image to build Hadoop and Big Data projects with Apache Bigtop

FROM ubuntu:16.04

# Must do this before building toolchain. toolchain creates user jerkins.
RUN useradd -u 1000 hdiuser

# Install prerequisites - JDK 8, puppet, puppetlabs-apt, bigtop toolchain.
# lsb-release is required for puppetlabs-apt, puppetlabs-apt is required to get puppet in toolchain to work.
# Also preinstalling packages since bigtop toolchain fails to install them.
RUN apt-get -y update && apt-get -y upgrade && apt-get -y clean && \
    apt-get install -y --no-install-recommends \
      asciidoc \
      curl \
      git \
      libssl-dev \
      lsb-release \
      openjdk-8-jdk \
      sudo \
      unzip \
      wget && \
    # Install azure cli and blobxfer to publish APT repo.
    apt-get install -y python-pip && \
    sudo pip -q install azure-cli blobxfer && \
    wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb && \
    dpkg -i puppetlabs-release-pc1-xenial.deb && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y puppet && \
    puppet module install puppetlabs-apt

# Install toolchain.
RUN git clone -b imagebuild2 https://github.com/felixcheung/bigtop.git && \
    cd bigtop && \
    ./gradlew toolchain

# Create home dir and add build user to sudoers.
RUN mkdir /home/hdiuser && \
    chown hdiuser:hdiuser /home/hdiuser && \
    usermod -aG sudo hdiuser && \
    echo "hdiuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Import GPG key for signing deb packages.
ENV GPG_TMP_PATH /tmp/hdiapt.private.gpg.key
ADD hdiapt.private.gpg.key /tmp
RUN sudo -Hu hdiuser gpg --import $GPG_TMP_PATH && \
    echo "export APT_SIGNING_GPG_KEY="$(gpg --with-colon $GPG_TMP_PATH | grep ssb | cut -d ":" -f 5) > /etc/profile.d/apt-signing-gpg-key.sh && \
    rm $GPG_TMP_PATH

ADD publish-apt-repo.sh /usr/bin

USER hdiuser

# Use sudo to load /etc/profile.d
ENTRYPOINT ["sudo", "-i", "-u", "hdiuser"]

CMD ["echo", "HDI BigTop builder"]
