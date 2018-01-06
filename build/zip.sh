#!/bin/bash

set -e

# enter images directory
pushd /build/jdk9u/build/linux-arm-normal-client-release/images

# clean destinations
rm -rf ./jre-ev3
rm -rf ./jdk-pc
rm -rf ./jshell-support
rm     ./jdk-ev3

# build ev3 runtime image
/opt/jdkcross/jdk-9.0.1/bin/jlink \
   --module-path ./jmods/ \
   --endian little \
   --compress 0 \
   --strip-debug \
   --no-header-files \
   --no-man-pages \
   --add-modules java.se,jdk.jdwp.agent,jdk.jshell \
   --output ./jre-ev3

# build microjdk
/opt/jdkcross/jdk-9.0.1/bin/jlink \
   --module-path /opt/jdkcross/jdk-9.0.1/jmods \
   --compress 2 \
   --strip-debug \
   --no-header-files \
   --no-man-pages \
   --add-modules java.se,jdk.attach,jdk.jdwp.agent,jdk.jlink,jdk.jartool,jdk.compiler,jdk.jdi,jdk.jshell \
   --output ./jdk-pc

cp -r ./jmods ./jdk-pc/jmods-ev3

# rename jdk directory
ln -s ./jdk ./jdk-ev3

# JShell hack
mkdir jshell-support
/opt/jdkcross/jdk-9.0.1/bin/javac -d ./jshell-support /opt/jdkcross/jshellhack/DumpPort.java
/opt/jdkcross/jdk-9.0.1/bin/jar cf ./jshellhack.jar -C ./jshell-support jshellhack/DumpPort.class
cp ./jshellhack.jar               ./jdk-pc/bin
cp /opt/jdkcross/jshell-launch.sh ./jdk-pc/bin

# create zip files
zip -9r /build/jdk-ev3.zip jdk-ev3
zip -9r /build/jre-ev3.zip jre-ev3
zip -9r /build/jdk-pc.zip  jdk-pc

popd
