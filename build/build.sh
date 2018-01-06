#!/bin/bash
cd /build/jdk9u
bash ./common/autoconf/autogen.sh
bash ./configure --with-boot-jdk=/opt/jdkcross/jdk-9.0.1 \
                 --openjdk-target=arm-linux-gnueabi \
                 --with-abi-profile=arm-ev3 \
                 --enable-headless-only \
                 --with-freetype-lib=/usr/lib/arm-linux-gnueabi \
                 --with-freetype-include=/usr/include \
                 --with-jvm-variants=client \
                 --with-extra-cflags="-Wno-maybe-uninitialized -D__SOFTFP__" \
                 --with-version-string="9.0.1" \
                 AR="arm-linux-gnueabi-gcc-ar" \
                 NM="arm-linux-gnueabi-gcc-nm" \
                 BUILD_AR="gcc-ar" \
                 BUILD_NM="gcc-nm"
make clean images
