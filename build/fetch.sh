#!/usr/bin/env bash
cd /build
hg clone http://hg.openjdk.java.net/jdk-updates/jdk9u/
cd jdk9u
bash ./get_source.sh
patch -p1            < /opt/jdkcross/ev3.patch
patch -p1 -d hotspot < /opt/jdkcross/float.patch

