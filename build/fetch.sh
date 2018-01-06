#!/usr/bin/env bash

# clone the root project
cd /build
hg clone http://hg.openjdk.java.net/jdk-updates/jdk9u/
cd jdk9u

# clone the rest of the tree
bash ./get_source.sh

# apply the EV3-specific patches
patch -p1            < /opt/jdkcross/ev3.patch
patch -p1 -d hotspot < /opt/jdkcross/float.patch

