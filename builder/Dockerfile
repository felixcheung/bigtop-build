# Docker image to build Hadoop and Big Data projects with Apache Bigtop

FROM ubuntu:16.04

RUN useradd -u 1000 hdiuser && \
    mkdir /home/hdiuser && \
    chown hdiuser:hdiuser /home/hdiuser && \
    usermod -aG sudo hdiuser && \
    echo "hdiuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
 
# Install prerequisites - jdk 8, puppet, puppetlabs-apt, bigtop toolchain
# And git clone bigtop source
# lsb-release is required for puppetlabs-apt, puppetlabs-apt is required to get puppet in toolchain to work
RUN apt-get -y update && apt-get -y upgrade && apt-get -y clean && \
    apt-get install --no-install-recommends -y curl wget sudo unzip git lsb-release && \
    apt-get install --no-install-recommends -y libssl-dev openjdk-8-jdk && \
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

USER hdiuser

CMD ["echo", "HDI BigTop builder"]