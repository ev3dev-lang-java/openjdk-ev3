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


if [ "$JDKVER" -eq "9" ]; then
  JAVA_REPO="http://hg.openjdk.java.net/jdk-updates/jdk9u/"
  PATCHVER="jdk9"
  AUTOGEN_PATH="./common/autoconf/autogen.sh"
elif [ "$JDKVER" -eq "10" ]; then
  JAVA_REPO="http://hg.openjdk.java.net/jdk-updates/jdk10u/"
  PATCHVER="jdk10"
  AUTOGEN_PATH="./make/autoconf/autogen.sh"
else
  echo "Error! Please specify JDK version to compile via the JDKVER environment variable." >&2
  echo "Acceptable values:" >&2
  echo "JDKVER=9" >&2
  echo "JDKVER=10" >&2
  exit 1
fi
