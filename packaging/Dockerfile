FROM ev3dev/ev3dev-stretch-ev3-base

# copy QEMU
COPY qemu-arm-static /usr/bin/qemu-arm-static

# install packaging utilities
RUN ["/usr/bin/qemu-arm-static", "/bin/bash", "-c", \
     "apt-get -q update && DEBIAN_FRONTEND=noninteractive apt-get -q install --yes --no-install-recommends devscripts debhelper fakeroot zip unzip gnupg dctrl-tools dput"]

# prepare a nonroot user
COPY compiler.sudoers /etc/sudoers.d/compiler
RUN ["/usr/bin/qemu-arm-static", "/bin/bash", "-c", \
    "chmod 0440 /etc/sudoers.d/compiler && adduser --disabled-password --gecos \"\" compiler && usermod -a -G sudo compiler"]

# copy build patches & scripts
COPY *.awk *.patch *.sh /opt/jdkpkg/
COPY debian/ /opt/jdkpkg/debian/
RUN ["/usr/bin/qemu-arm-static", "/bin/bash", "-c", "chmod +x /opt/jdkpkg/*.sh"]

# this directory should be mounted
VOLUME /build

USER compiler
WORKDIR /opt/jdkpkg
CMD ["/usr/bin/qemu-arm-static", "/bin/bash", "/opt/jdkpkg/package.sh"]
