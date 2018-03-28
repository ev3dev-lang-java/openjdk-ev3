#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source config.sh

# clone the root project
hg clone "$JAVA_REPO" "$JDKDIR"

# clone the rest of the tree
cd "$JDKDIR"

# apply the EV3-specific patches
patch -p1 < "$SCRIPTDIR/all.patch"

