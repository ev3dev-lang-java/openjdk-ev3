#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source config.sh

# clone the root project
hg clone "$JAVA_REPO" "$JDKDIR"

# clone the rest of the tree
cd "$JDKDIR"
bash ./get_source.sh

# apply the EV3-specific patches
#  - build flags for arm926ej-s
patch -p1            < "$SCRIPTDIR/ev3.patch"
#  - use the system-provided floating point implementation
patch -p1 -d hotspot < "$SCRIPTDIR/float.patch"

