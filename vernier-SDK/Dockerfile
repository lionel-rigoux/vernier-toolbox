# Pull base image.
FROM ubuntu:18.04

# Install.
RUN apt-get -qq -y update --fix-missing
RUN apt-get -qq -y upgrade
RUN apt-get -qq -y install curl wget zip git sudo

RUN apt-get -qq -y install aptitude
RUN aptitude install -y build-essential
RUN aptitude install -y automake
RUN aptitude install -y dpkg-dev
RUN aptitude install -y libtool
RUN aptitude install -y libusb-1.0-0-dev
RUN aptitude install -y uuid-dev

ADD GoIO_SDK/src /GoIO_SDK/
WORKDIR /GoIO_SDK

RUN ./build.sh

CMD cp /usr/lib/libGoIO.so /opt/mount/
