# Docker image to build Hadoop and Big Data projects with Apache Bigtop

FROM ubuntu:16.04

# Must do this before building toolchain. toolchain creates user jerkins.
RUN useradd -u 1000 hdiuser

# Install prerequisites - jdk 8, puppet, puppetlabs-apt, bigtop toolchain
# And git clone bigtop source
# lsb-release is required for puppetlabs-apt, puppetlabs-apt is required to get puppet in toolchain to work
RUN apt-get -y update && apt-get -y upgrade && apt-get -y clean && \
    apt-get install --no-install-recommends -y curl wget sudo unzip git lsb-release && \
    apt-get install --no-install-recommends -y libssl-dev openjdk-8-jdk && \
    wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb && \
    dpkg -i puppetlabs-release-pc1-xenial.deb && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y puppet && \
    puppet module install puppetlabs-apt && \
    # preinstalling packages since bigtop toolchain fails to install it
    apt-get install --no-install-recommends -y asciidoc && \
    git clone -b imagebuild2 https://github.com/felixcheung/bigtop.git && \
    cd bigtop && \
    ./gradlew toolchain

# Add hdiuser to sudoers.
RUN mkdir /home/hdiuser && \
    chown hdiuser:hdiuser /home/hdiuser && \
    usermod -aG sudo hdiuser && \
    echo "hdiuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Import GPG key for signing deb packages.
ADD hdiapt.private.gpg.key /home/hdiuser
RUN cd /home/hdiuser && \
    gpg --import hdiapt.private.gpg.key && \
    APT_SIGNING_GPG_KEY=$(gpg --with-colon hdiapt.private.gpg.key | grep ssb | cut -d ":" -f 5) && \
    echo "export APT_SIGNING_GPG_KEY=$APT_SIGNING_GPG_KEY" >> /etc/profile.d/apt-signing-gpg-key.sh

USER hdiuser

# Use sudo to load /etc/profile.d
ENTRYPOINT ["sudo", "-i", "-u", "hdiuser"]

CMD ["echo", "HDI BigTop builder"]
