#!/usr/bin/env bash
set -e

# clone the root project
pushd /build
hg clone http://hg.openjdk.java.net/jdk-updates/jdk9u/
pushd jdk9u

# clone the rest of the tree
bash ./get_source.sh

# apply the EV3-specific patches
#  - build flags for arm926ej-s
patch -p1            < /opt/jdkcross/ev3.patch
#  - use the system-provided floating point implementation
patch -p1 -d hotspot < /opt/jdkcross/float.patch

