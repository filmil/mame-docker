# Copyright 2023 Google. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

FROM ubuntu:22.04 as build

ARG NCPU=10

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "dash dash/sh boolean false" | debconf-set-selections 
RUN DEBIAN_FRONTEND=$DEBIAN_FRONTEND dpkg-reconfigure dash

RUN apt-get update

RUN apt-get install -y \
  autoconf \
  bash \
  build-essential \
  dos2unix \
  gawk \
  gcc-multilib \
  git \
  iproute2 \
  less \
  libfontconfig-dev \
  libglib2.0-dev \
  libncurses5-dev \
  libpulse-dev \
  libsdl1.2-dev \
  libsdl2-dev \
  libsdl2-ttf-dev \
  libtool \
  libtool-bin \
  locales \
  locales-all \
  lsb-release \
  make \
  python3 \
  qt5-qmake \
  qtbase5-dev \
  qtbase5-dev-tools \
  qtchooser \
  rsync \
  tar \
  tofrodos \
  unzip \
  wget \
  xterm \
  zlib1g-dev \
  ""

# TODO: filmil - there is a more canonical way to set the locale.
RUN env LANG=en_US.UTF-8 locale-gen --purge en_US.UTF-8 \
	&& echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

RUN mkdir -p /tmp/build/mame
RUN cd /tmp/build/mame \
  && wget https://github.com/mamedev/mame/archive/refs/tags/mame0261.tar.gz \
  && tar xzvvf mame0261.tar.gz

ENV HOME=/home/user
RUN mkdir $HOME

RUN cd /tmp/build/mame \
  && cd mame-mame0261 \
  && make VERBOSE=1 NO_X11=0 USE_WAYLAND=0 USE_SDL=1 \
          SOURCES=src/mame/sfrj/tim011.cpp SUBTARGET=tim011 -j ${NCPU}

VOLUME /src
VOLUME /work
WORKDIR /work

FROM ubuntu:22.04

ARG NCPU=10

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "dash dash/sh boolean false" | debconf-set-selections 
RUN DEBIAN_FRONTEND=$DEBIAN_FRONTEND dpkg-reconfigure dash

RUN apt-get update

RUN apt-get install -y \
  alsa-utils \
  bash \
  less \
  libfontconfig-dev \
  libglib2.0-dev \
  libncurses5-dev \
  libpulse-dev \
  libsdl1.2-dev \
  libsdl2-dev \
  libsdl2-ttf-dev \
  libtool \
  libtool-bin \
  locales \
  locales-all \
  lsb-release \
  make \
  python3 \
  qt5-qmake \
  qtbase5-dev \
  qtbase5-dev-tools \
  qtchooser \
  rsync \
  tar \
  tofrodos \
  unzip \
  wget \
  xterm \
  zlib1g-dev \
  ""

RUN mkdir -p /prg
COPY --from=build /tmp/build/mame/mame-mame0261/tim011 /prg/tim011

RUN apt-get install -y \
  alsa-oss
