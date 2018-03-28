#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source config.sh

# enter images directory
cd "$IMAGEDIR"

# clean destinations
rm -rf ./jri-ev3

# build ev3 runtime image
"$HOSTJDK/bin/jlink" \
   --module-path ./jmods/ \
   --endian little \
   --compress 0 \
   --strip-debug \
   --no-header-files \
   --no-man-pages \
   --add-modules java.se,jdk.jdwp.agent \
   --output ./jri-ev3

# create zip files
tar -cf - jri-ev3 | pigz -9 > "$BUILDDIR/jri-ev3.tar.gz"
tar -cf - jdk     | pigz -9 > "$BUILDDIR/jdk-ev3.tar.gz"
tar -cf - jmods   | pigz -9 > "$BUILDDIR/jmods.tar.gz"
