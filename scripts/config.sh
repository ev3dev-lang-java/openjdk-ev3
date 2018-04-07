#!/bin/bash

# scripts root directory
SCRIPTDIR="$( cd "$(dirname "$0")" ; pwd -P )"
# output directory
BUILDDIR="/build"
# jdk repository directory
JDKDIR="/build/jdk"

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
  JAVA_REPO="http://hg.openjdk.java.net/jdk-updates/jdk9u/"
  PATCHVER="jdk9"
  AUTOGEN_STYLE="v1"
  AUTOGEN_PATH="./common/autoconf/autogen.sh"
  HOSTJDK="$BUILDDIR/jdk-9.0.4"
  HOSTJDK_FILE="$BUILDDIR/openjdk-9.0.4_linux-x64_bin.tar.gz"
  HOSTJDK_URL="https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz"

# OpenJDK 10
elif [ "$JDKVER" == "10" ]; then
  JAVA_REPO="http://hg.openjdk.java.net/jdk-updates/jdk10u/"
  PATCHVER="jdk10"
  AUTOGEN_STYLE="v1"
  AUTOGEN_PATH="./make/autoconf/autogen.sh"
  HOSTJDK="$BUILDDIR/jdk-10"
  HOSTJDK_FILE="$BUILDDIR/openjdk-10_linux-x64_bin.tar.gz"
  HOSTJDK_URL="https://download.java.net/java/GA/jdk10/10/binaries/openjdk-10_linux-x64_bin.tar.gz"

# OpenJDK Master+dev
elif [ "$JDKVER" == "dev" ]; then
  JAVA_REPO="http://hg.openjdk.java.net/jdk/jdk/"
  PATCHVER="jdkdev"
  AUTOGEN_STYLE="v2"
  HOSTJDK="$BUILDDIR/jdk-10"
  HOSTJDK_FILE="$BUILDDIR/openjdk-10_linux-x64_bin.tar.gz"
  HOSTJDK_URL="https://download.java.net/java/GA/jdk10/10/binaries/openjdk-10_linux-x64_bin.tar.gz"


# invalid or unset version
else
  echo "Error! Please specify JDK version to compile via the JDKVER environment variable." >&2
  echo "Acceptable values:" >&2
  echo "JDKVER=9" >&2
  echo "JDKVER=10" >&2
  echo "JDKVER=dev" >&2
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
