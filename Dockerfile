## Installation
#
#    cd /dir/where/this/dockerfile/is && sudo docker build -rm -t -i 'you/name-it'
#

FROM ubuntu
MAINTAINER Jose Pinheiro Neta <jose.neta@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

RUN apt-get update
RUN apt-get upgrade
RUN apt-get clean

RUN apt-get install -y --force-yes build-essential bash-completion perl-doc man wget curl tree git syslog-ng tmux zip unzip vim

# Install Broker Client

## Thrift dependencies (http://thrift.apache.org/docs/install/ubuntu/)
RUN apt-get install -y -q perl libboost-dev libboost-test-dev libboost-program-options-dev libevent-dev automake libtool flex bison pkg-config libssl-dev 
RUN apt-get clean
# you may need to install dependencies from CPAN
# http://git-wip-us.apache.org/repos/asf/thrift.git

# Intall Thrift
ADD http://mirrors.fe.up.pt/pub/apache/thrift/0.9.1/thrift-0.9.1.tar.gz /

RUN tar -xzf thrift-0.9.1.tar.gz ;\
  cd thrift-0.9.1/lib/perl/ ;\
  perl Makefile.PL ;\
  make ;\
  make install;

RUN apt-get clean

ADD https://dl-web.meocloud.pt/dlweb/download/DONOTSYNC/SAPO/sapo-broker-4.0.44.tar.gz?public=35139098-49e8-4c18-bfc8-f8f40701b9ae /
RUN tar -xvzf sapo-broker-4.0.44.tar.gz 

RUN cd sapo-broker-4.0.44/clients/perl ;\
  /bin/echo -e "yes\nyes\nno\nyes\nyes" | perl Makefile.PL ;\
  make ;\
  make install;

#RUN echo "yes\nyes\n" | cpan CPAN Readonly Class::Accessor Bit::Vector JSON
RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm --notest Readonly Class::Accessor Bit::Vector JSON

ADD publisher.pl /sapo-broker-4.0.44/clients/perl/examples/
ADD subscriber.pl /sapo-broker-4.0.44/clients/perl/examples/

# Default broker server
ENV PUBLIC_SAPO_BROKER_AGENT broker.labs.sapo.pt 

WORKDIR /sapo-broker-4.0.44/clients/perl/examples
