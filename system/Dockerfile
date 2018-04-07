FROM debian:stretch

# this is a customized version of ev3dev-stretch-cross image

# setup repositories and install required packages
COPY apt.sources.list.debian /etc/apt/sources.list
COPY ev3dev-archive-keyring.gpg /etc/apt/trusted.gpg.d/
RUN dpkg --add-architecture armel && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        bash-completion \
        ca-certificates \
        cmake \
        build-essential \
        crossbuild-essential-armel \
        gdb-multiarch \
        less \
        man-db \
        nano \
        pkg-config \
        qemu-user-static \
        sudo \
        tree \
        vim \
        wget \
        xz-utils \
        libcups2-dev:armel \
        libfreetype6-dev:armel \
        libfontconfig1-dev:armel \
        libasound2-dev:armel \
        libx11-dev:armel \
        libxext-dev:armel \
        libxrender-dev:armel \
        libxtst-dev:armel \
        libxt-dev:armel \
        libffi-dev:armel \
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
        zlib1g-dev

# prepare a nonroot user
COPY compiler.sudoers /etc/sudoers.d/compiler
RUN chmod 0440 /etc/sudoers.d/compiler && \
    adduser --disabled-password --gecos \"\" compiler && \
    usermod -a -G sudo compiler
