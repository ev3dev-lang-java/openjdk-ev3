#!/bin/bash

# scripts root directory
SCRIPTDIR="$( cd "$(dirname "$0")" ; pwd -P )"
# output directory
BUILDDIR="/build"
# jdk repository directory
JDKDIR="$BUILDDIR/jdk"
# softfloat repository directory
SFLTDIR="$BUILDDIR/sflt"
# softfloat repository
SFLTREPO="https://github.com/ev3dev-lang-java/softfloat-openjdk.git"
# softfloat build directory
SFLTBUILD="$SFLTDIR/build/Linux-ARM-VFPv2-GCC-OpenJDK"
# softfloat static library
SFLTLIB="$SFLTBUILD/softfloat.a"
# openjdk-build repo dir
ABLDDIR="$BUILDDIR/openjdk-build"
# openjdk-build repo
ABLDREPO="https://github.com/AdoptOpenJDK/openjdk-build.git"
# cacertfile
CACERTFILE="$ABLDDIR/security/cacerts"

##
## Version-specific configuration
##

# output images directory
#IMAGEDIR="/build/jdk/build/linux-arm-normal-client-release/images"

# mercurial repository
#JAVA_REPO="http://hg.openjdk.java.net/jdk-updates/jdkXu/"

# patch to apply
#PATCHVER="jdkX"

# path to autogen.sh to regenerate the build system
#AUTOGEN_PATH="./common/autoconf/autogen.sh"

# hotspot variant to use
#HOTSPOT_VARIANT=client
# A comment from OpenJDK build system sums it up pretty well:
##   server: normal interpreter, and a tiered C1/C2 compiler
##   client: normal interpreter, and C1 (no C2 compiler)
##   minimal: reduced form of client with optional features stripped out
##   core: normal interpreter only, no compiler
##   zero: C++ based interpreter only, no compiler
##   custom: baseline JVM with no default features
# 'client' JVM starts fast enough and provides the best performance.
# 'zero' JVM provides us with a fallback when ARMv5 sflt JIT stops working completely.

## Boot JDK configs

# Destination Boot JDK directory
#HOSTJDK="$BUILDDIR/jdk-9.0.4"

# Cached archive
#HOSTJDK_FILE="$BUILDDIR/openjdk-9.0.4.tar.gz"

# Download URL
#HOSTJDK_URL="https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz"

# OpenJDK 9
if [ "$JDKVER" == "9" ]; then
  JAVA_REPO="https://github.com/AdoptOpenJDK/openjdk-jdk9u.git"
  JAVA_SCM="git"
  PATCHVER="jdk9"
  AUTOGEN_STYLE="v1"
  AUTOGEN_PATH="./common/autoconf/autogen.sh"
  HOSTJDK="$BUILDDIR/jdk-9.0.4"
  HOSTJDK_FILE="$BUILDDIR/openjdk-9.0.4_linux-x64_bin.tar.gz"
  HOSTJDK_URL="https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz"

# OpenJDK 10
elif [ "$JDKVER" == "10" ]; then
  JAVA_REPO="https://github.com/AdoptOpenJDK/openjdk-jdk10u.git"
  JAVA_SCM="git"
  PATCHVER="jdk10"
  AUTOGEN_STYLE="v1"
  AUTOGEN_PATH="./make/autoconf/autogen.sh"
  HOSTJDK="$BUILDDIR/jdk-10.0.2"
  HOSTJDK_FILE="$BUILDDIR/openjdk-10.0.2_linux-x64_bin.tar.gz"
  HOSTJDK_URL="https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz"

# OpenJDK 11
elif [ "$JDKVER" == "11" ]; then
  JAVA_REPO="https://github.com/AdoptOpenJDK/openjdk-jdk11.git"
  JAVA_SCM="git"
  PATCHVER="jdk11"
  AUTOGEN_STYLE="v2"
  HOSTJDK="$BUILDDIR/jdk-11.0.1"
  HOSTJDK_FILE="$BUILDDIR/openjdk-11.0.1_linux-x64_bin.tar.gz"
  HOSTJDK_URL="https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz"

# OpenJDK Master+dev
elif [ "$JDKVER" == "12" ]; then
  JAVA_REPO="http://hg.openjdk.java.net/jdk/jdk/archive/tip.tar.bz2"
  JAVA_SCM="hg_zip"
  JAVA_BZ2="$BUILDDIR/tip.tar.bz2"
  JAVA_TMP="$BUILDDIR/jdk_tmp"
  PATCHVER="jdk12"
  AUTOGEN_STYLE="v2"
  HOSTJDK="$BUILDDIR/jdk-11.0.1"
  HOSTJDK_FILE="$BUILDDIR/openjdk-11.0.1_linux-x64_bin.tar.gz"
  HOSTJDK_URL="https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz"


# invalid or unset version
else
  echo "Error! Please specify JDK version to compile via the JDKVER environment variable." >&2
  echo "Acceptable values:" >&2
  echo "JDKVER=9" >&2
  echo "JDKVER=10" >&2
  echo "JDKVER=11" >&2
  echo "JDKVER=12" >&2
  exit 1
fi


# EV3
if [ "$JDKPLATFORM" == "ev3" ]; then
  SFLT_NEEDED=true

# Raspberry Pi 1
elif [ "$JDKPLATFORM" == "rpi1" ]; then
  SFLT_NEEDED=false

# Raspberry Pi 2
elif [ "$JDKPLATFORM" == "rpi2" ]; then
  SFLT_NEEDED=false

# Raspberry Pi 3
elif [ "$JDKPLATFORM" == "rpi3" ]; then
  SFLT_NEEDED=false

# invalid or unset platform
else
  echo "Error! Please specify JDK platform to compile via the JDKPLATFORM environment variable." >&2
  echo "Acceptable values:" >&2
  echo "JDKPLATFORM=ev3" >&2
  echo "JDKPLATFORM=rpi1" >&2
  echo "JDKPLATFORM=rpi2" >&2
  echo "JDKPLATFORM=rpi3" >&2
  exit 1
fi



# invalid or unset VM
if [ "$JDKVM" != "zero" ] && [ "$JDKVM" != "client" ]; then
  echo "Error! Please specify JDK VM to compile via the JDKVM environment variable." >&2
  echo "Acceptable values:" >&2
  echo "JDKVM=client" >&2
  echo "JDKVM=zero" >&2
  exit 1
fi

HOTSPOT_VARIANT="$JDKVM"
IMAGEDIR="/build/jdk/build/linux-arm-normal-${JDKVM}-release/images"
