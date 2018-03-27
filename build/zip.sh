#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source config.sh

# enter images directory
cd "$IMAGEDIR"

# clean destinations
rm -rf ./jre-ev3

# build ev3 runtime image
"$SCRIPTDIR/jdk-10/bin/jlink" \
   --module-path ./jmods/ \
   --endian little \
   --compress 0 \
   --strip-debug \
   --no-header-files \
   --no-man-pages \
   --add-modules java.se,jdk.jdwp.agent \
   --output ./jre-ev3

# create zip files
tar -cf - jre-ev3 | pigz -9 > "$BUILDDIR/jre-ev3.tar.gz"
tar -cf - jdk     | pigz -9 > "$BUILDDIR/jdk-ev3.tar.gz"
tar -cf - jmods   | pigz -9 > "$BUILDDIR/jmods.tar.gz"
