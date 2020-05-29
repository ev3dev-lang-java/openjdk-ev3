ARG DEBIAN_RELEASE=stretch
FROM ev3dev/ev3dev-$DEBIAN_RELEASE-ev3-base

ARG DEBIAN_RELEASE
ENV DISTRO=$DEBIAN_RELEASE

# copy QEMU for x86 hosts (binfmt_misc is required)
COPY qemu-arm-static /usr/bin/qemu-arm-static

# install packaging utilities
RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install --yes --no-install-recommends \
        devscripts debhelper fakeroot \
        zip unzip \
        gnupg dctrl-tools dput \
        liblcms2-2 \
        pigz xz-utils

# prepare a nonroot user
COPY compiler.sudoers /etc/sudoers.d/compiler
RUN chmod 0440 /etc/sudoers.d/compiler && \
    adduser --disabled-password --gecos \"\" compiler && usermod -a -G sudo compiler

# copy build patches & scripts
COPY *.awk *.patch *.sh /opt/jdkpkg/
COPY debian/ /opt/jdkpkg/debian/
RUN chmod +x /opt/jdkpkg/*.sh

USER compiler
WORKDIR /opt/jdkpkg
CMD ["/bin/bash", "-c", "/opt/jdkpkg/package.sh"]
