ARG DEBIAN_RELEASE=stretch
ARG ARCH=armel
FROM ev3dev/debian-$DEBIAN_RELEASE-$ARCH-qemu-minbase
ARG DEBIAN_RELEASE
ARG ARCH

# this is a customized version of ev3dev-stretch-cross image

# setup repositories and install required packages
COPY sources.list.$DEBIAN_RELEASE /etc/apt/sources.list
COPY ev3dev-archive-keyring.gpg /etc/apt/trusted.gpg.d/
RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install --yes --no-install-recommends \
        bash-completion \
        ca-certificates \
        cmake \
        build-essential \
        gdb-multiarch \
        less \
        man-db \
        nano \
        pkg-config \
        sudo \
        tree \
        vim \
        wget \
        xz-utils \
        libcups2-dev       \
        libfreetype6-dev   \
        libfontconfig1-dev \
        libasound2-dev     \
        libx11-dev         \
        libxext-dev        \
        libxrender-dev     \
        libxrandr-dev      \
        libxtst-dev        \
        libxt-dev          \
        libffi-dev         \
        libpng-dev         \
        libjpeg-dev        \
        libgif-dev         \
        liblcms2-dev       \
        zlib1g-dev         \
        systemtap          \
        systemtap-sdt-dev  \
        curl \
        make \
        m4 \
        cpio \
        gawk \
        file \
        zip \
        pigz \
        unzip \
        procps \
        autoconf \
        autoconf-archive \
        automake \
        autotools-dev \
        mercurial \
        git \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# prepare a nonroot user
COPY compiler.sudoers /etc/sudoers.d/compiler
RUN chmod 0440 /etc/sudoers.d/compiler && \
    adduser --disabled-password --gecos \"\" compiler && \
    usermod -a -G sudo compiler
