#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source config.sh
source "$BUILDDIR/jver.sh"

cd "$JDKDIR"

# refresh patched build system
echo "[BUILD] Regenerating autoconf"
if   [ "$AUTOGEN_STYLE" == "v1" ]; then
  bash "$AUTOGEN_PATH"
elif [ "$AUTOGEN_STYLE" == "v2" ]; then
  bash ./configure autogen || true
fi

## Description ##
# Use the downloaded JDK:      --with-boot-jdk=/opt/jdkcross/jdk-10
# Cross-compiling for ARM:     --openjdk-target=arm-linux-gnueabi
# Tune for ARM926EJ-S softfp:  --with-abi-profile=arm-ev3
# Disable GUI:                 --enable-headless-only
# Help to find freetype:       --with-freetype-lib=/usr/lib/arm-linux-gnueabi
#                              --with-freetype-include=/usr/include
# Build only the right VM:     --with-jvm-variants=client
# Add extra build flags:       --with-extra-cflags="-w -Wno-error -D__SOFTFP__"
#                              --with-extra-cxxflags="-w -Wno-error -D__SOFTFP__"
#   - Fix the build on new GCC: -w -Wno-error
#   - Force softfloat runtime:  -D__SOFTFP__
# Fix the "internal" string:   --with-version-string="10+46-ev3"
# Fix for GCC and LTO objects: AR="arm-linux-gnueabi-gcc-ar"
#                              NM="arm-linux-gnueabi-gcc-nm"
#                              BUILD_AR="gcc-ar"
#                              BUILD_NM="gcc-nm"

# configure the build
echo "[BUILD] Configuring Java for target '$JDKPLATFORM'"

if [ "$JDKPLATFORM" == "ev3" ]; then
  LIBFFI_LIBS=-lffi_pic \
  bash ./configure --with-boot-jdk="$HOSTJDK" \
                   --openjdk-target=arm-linux-gnueabi \
                   --with-abi-profile="$HOTSPOT_ABI" \
                   --enable-headless-only \
                   --with-freetype-lib=/usr/lib/arm-linux-gnueabi \
                   --with-freetype-include=/usr/include \
                   --with-jvm-variants="$HOTSPOT_VARIANT" \
                   --with-extra-cflags="-w -Wno-error -D__SOFTFP__" \
                   --with-extra-cxxflags="-w -Wno-error -D__SOFTFP__" \
                   --with-version-string="$JAVA_VERSION" \
                   --with-cacerts-file="$CACERTFILE" \
                   --with-debug-level=release \
                   AR="arm-linux-gnueabi-gcc-ar" \
                   NM="arm-linux-gnueabi-gcc-nm" \
                   BUILD_AR="gcc-ar" \
                   BUILD_NM="gcc-nm"
fi

# start the build
echo "[BUILD] Building Java"
make clean images
