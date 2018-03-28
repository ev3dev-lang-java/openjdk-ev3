#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source config.sh

# enter images directory
cd "$IMAGEDIR"

# clean destinations
rm -rf ./jre-ev3
rm -rf ./jdk-pc
rm -rf ./jshell-support
rm -f  ./jdk-ev3

# build ev3 runtime image
"$SCRIPTDIR/jdk-9.0.4/bin/jlink" \
   --module-path ./jmods/ \
   --endian little \
   --compress 0 \
   --strip-debug \
   --no-header-files \
   --no-man-pages \
   --add-modules java.se,jdk.jdwp.agent,jdk.jshell \
   --output ./jre-ev3

# build microjdk
"$SCRIPTDIR/jdk-9.0.4/bin/jlink" \
   --module-path "$SCRIPTDIR/jdk-9.0.4/jmods" \
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
"$SCRIPTDIR/jdk-9.0.4/bin/javac" -d ./jshell-support "$SCRIPTDIR/jshellhack/DumpPort.java"
"$SCRIPTDIR/jdk-9.0.4/bin/jar" cf ./jshellhack.jar -C ./jshell-support jshellhack/DumpPort.class
cp ./jshellhack.jar ./jdk-pc/bin
cp "$SCRIPTDIR/jshell-launch.sh" ./jdk-pc/bin

# create zip files
zip -9r "$BUILDDIR/jdk-ev3.zip" jdk-ev3
zip -9r "$BUILDDIR/jre-ev3.zip" jre-ev3
zip -9r "$BUILDDIR/jdk-pc.zip"  jdk-pc
