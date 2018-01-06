#!/bin/bash

set -e

# enter images directory
pushd /build/jdk9u/build/linux-arm-normal-client-release/images

# build ev3 runtime image
/opt/jdkcross/jdk-9.0.1/bin/jlink \
   --module-path ./jmods/ \
   --endian little \
   --compress 0 \
   --strip-debug \
   --add-modules java.se \
   --output ./jre-ev3

# rename jdk directory
ln -s ./jdk ./jdk-ev3

# create zip files
zip -r /build/jdk-ev3.zip jdk-ev3
zip -r /build/jre-ev3.zip jre-ev3

popd
