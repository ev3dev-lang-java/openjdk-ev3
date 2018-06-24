FROM debian:stretch

# this is a customized version of ev3dev-stretch-cross image

# setup repositories and install required packages
COPY apt.sources.list.debian /etc/apt/sources.list
COPY ev3dev-archive-keyring.gpg /etc/apt/trusted.gpg.d/
RUN dpkg --add-architecture armel && dpkg --add-architecture armhf && \
    apt-get -q update && \
    DEBIAN_FRONTEND=noninteractive apt-get -q install --yes --no-install-recommends \
        bash-completion \
        ca-certificates \
        cmake \
        build-essential \
        crossbuild-essential-armel crossbuild-essential-armhf \
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
        libcups2-dev:armel       libcups2-dev:armhf       \
        libfreetype6-dev:armel   libfreetype6-dev:armhf   \
        libfontconfig1-dev:armel libfontconfig1-dev:armhf \
        libasound2-dev:armel     libasound2-dev:armhf     \
        libx11-dev:armel         libx11-dev:armhf         \
        libxext-dev:armel        libxext-dev:armhf        \
        libxrender-dev:armel     libxrender-dev:armhf     \
        libxtst-dev:armel        libxtst-dev:armhf        \
        libxt-dev:armel          libxt-dev:armhf          \
        libffi-dev:armel         libffi-dev:armhf         \
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
