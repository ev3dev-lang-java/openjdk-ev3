#!/bin/bash

# scripts root directory
SCRIPTDIR="$( cd "$(dirname "$0")" ; pwd -P )"
# output directory
BUILDDIR="/build"
# jdk repository directory
JDKDIR="/build/jdk"
# output images directory
IMAGEDIR="/build/jdk/build/linux-arm-normal-client-release/images"
# boot jdk
HOSTJDK="$SCRIPTDIR/jdk-10"


# Version-specific configuration

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


# OpenJDK 9
if [ "$JDKVER" -eq "9" ]; then
  JAVA_REPO="http://hg.openjdk.java.net/jdk-updates/jdk9u/"
  PATCHVER="jdk9"
  AUTOGEN_PATH="./common/autoconf/autogen.sh"
  HOTSPOT_VARIANT=client

# OpenJDK 10
elif [ "$JDKVER" -eq "10" ]; then
  JAVA_REPO="http://hg.openjdk.java.net/jdk-updates/jdk10u/"
  PATCHVER="jdk10"
  AUTOGEN_PATH="./make/autoconf/autogen.sh"
  HOTSPOT_VARIANT=client

# invalid or unset version
else
  echo "Error! Please specify JDK version to compile via the JDKVER environment variable." >&2
  echo "Acceptable values:" >&2
  echo "JDKVER=9" >&2
  echo "JDKVER=10" >&2
  exit 1
fi
