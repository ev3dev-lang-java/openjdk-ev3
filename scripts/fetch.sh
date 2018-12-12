#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source config.sh

if [ ! -d "$JDKDIR" ]; then

  if [ "$JAVA_SCM" == "hg_zip" ]; then
    cd "$BUILDDIR"

    # Identify latest HG tag
    JAVA_TAG="$(wget -nv "$HG_BASE_URL/raw-file/tip/.hgtags" -O - | tail -n 1 | cut -d " " -f 2)"

    # select URL for latest tag in given repo
    if [ "$JDKVER" == "tip" ]; then
      JAVA_DST="tip.tar.bz2"
    else
      JAVA_DST="$JAVA_TAG.tar.bz2"
    fi
    JAVA_URL="$HG_BASE_URL/archive/$JAVA_DST"

    # download it
    echo "[FETCH] Downloading Java tarball from Mercurial (tag $JAVA_TAG)"

    set +e
    wget -nv -N "$JAVA_URL"
    status=$?
    tries=1
    while [[ "$status" -ne "0" ]]; do

      if [[ "$tries" -gt "$TARBALL_MAX_DOWNLOADS" ]]; then
        echo "$TARBALL_MAX_DOWNLOADS download failed, giving up." 1>&2
        exit 1
      fi

      wget -nv -N "$JAVA_URL"
      status=$?
      tries=$(($tries+1))
    done
    set -e

    # extract
    echo "[FETCH] Extracting tarball"
    mkdir "$JAVA_TMP"
    tar -C "$JAVA_TMP" -xf "$JAVA_DST"

    # move to the right place
    # https://unix.stackexchange.com/a/156287
    pattern="$JAVA_TMP/*"
    files=( $pattern )
    mv "${files[0]}" "$JDKDIR"
    rmdir "$JAVA_TMP"

    # enter the jdk repo
    cd "$JDKDIR"

    # clone the rest of the tree, if needed
    if [ -f "./get_source.sh" ]; then
      echo "[FETCH] Downloading Java components"
      bash ./get_source.sh
    fi

    JAVA_VERSION="$(cat ./.hg_archival.txt | grep "latesttag:" | sed -E 's/^.*jdk-//')-ev3"
    JAVA_COMMIT="$(cat ./.hg_archival.txt | grep "node:" | sed -E 's/^node: //')"

  elif [ "$JAVA_SCM" == "git" ]; then
    latestTag="$($SCRIPTDIR/latest.awk "$JAVA_REPO")"
    JAVA_VERSION="$(echo "$latestTag" | sed 's/jdk-//')-ev3"

    # clone the root project
    echo "[FETCH] Cloning Java repo from Git"
    git clone --depth "1" --branch "$latestTag" "$JAVA_REPO" "$JDKDIR"

    # enter the jdk repo
    cd "$JDKDIR"
    JAVA_COMMIT="$(git rev-parse HEAD)"
  fi

  # build metadata
  echo "# ev3dev-lang-java openjdk build metadata"  >"$BUILDDIR/metadata"
  echo "JAVA_ORIGIN=\"$JAVA_SCM\""                 >>"$BUILDDIR/metadata"
  echo "JAVA_COMMIT=\"$JAVA_COMMIT\""              >>"$BUILDDIR/metadata"
  echo "JAVA_VERSION=\"$JAVA_VERSION\""            >>"$BUILDDIR/metadata"
  echo "CONFIG_VM=\"$JDKVM\""                      >>"$BUILDDIR/metadata"
  echo "CONFIG_DEBUG=\"$HOTSPOT_DEBUG\""           >>"$BUILDDIR/metadata"
  echo "CONFIG_VERSION=\"$JDKVER\""                >>"$BUILDDIR/metadata"
  echo "CONFIG_PLATFORM=\"$JDKPLATFORM\""          >>"$BUILDDIR/metadata"
  echo "CONFIG_MODULES=\"$JRI_MODULES\""           >>"$BUILDDIR/metadata"
  echo "BUILDER_COMMIT=\"$BUILDER_COMMIT\""        >>"$BUILDDIR/metadata"
  echo "BUILDER_EXTRA=\"$BUILDER_EXTRA\""          >>"$BUILDDIR/metadata"


  echo "[FETCH] Build metadata: "
  cat "$BUILDDIR/metadata"
  echo

  # apply the EV3-specific patches
  echo "[FETCH] Patching the source tree"
  if [ -f "$SCRIPTDIR/${PATCHVER}.patch" ]; then
    patch -p1 -i "$SCRIPTDIR/${PATCHVER}.patch"
  fi
  # debian library path
  if [ -f "$SCRIPTDIR/${PATCHVER}_lib.patch" ]; then
    patch -p1 -i "$SCRIPTDIR/${PATCHVER}_lib.patch"
  fi

else
  echo "[FETCH] Directory for JDK repository exists, assuming everything has been done already." 2>&1
fi


if [ ! -d "$SFLTDIR" ] && [ "$SFLT_NEEDED" == "true" ]; then
  # clone the root project
  echo "[FETCH] Cloning SoftFloat repo"
  git clone --depth 1 "$SFLTREPO" "$SFLTDIR"
fi


if [ -d "$ABLDDIR" ]; then
  rm -rf "$ABLDDIR"
fi

# clone the root project
echo "[FETCH] Cloning openjdk-build repo"
git clone --depth 1 "$ABLDREPO" "$ABLDDIR"
