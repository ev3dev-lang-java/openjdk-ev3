#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source config.sh

if [ ! -d "$JDKDIR" ]; then

  # clone the root project
  echo "[FETCH] Cloning Java repo"
  hg clone "$JAVA_REPO" "$JDKDIR"

  # enter the jdk repo
  cd "$JDKDIR"

  # clone the rest of the tree, if needed
  if [ -f "./get_source.sh" ]; then
    echo "[FETCH] Downloading Java components"
    bash ./get_source.sh
  fi

  # apply the EV3-specific patches
  echo "[FETCH] Patching the source tree"
  patch -p1 -i "$SCRIPTDIR/$PATCHVER.patch"

else
  echo "[FETCH] Directory for JDK repository exists, assuming everything has been done already." 2>&1
fi
