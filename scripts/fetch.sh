#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source config.sh

if [ ! -d "$JDKDIR" ]; then

  if [ "$JAVA_SCM" == "hg" ]; then
    # clone the root project
    echo "[FETCH] Cloning Java repo from Mercurial"
    hg clone "$JAVA_REPO" "$JDKDIR"

    # enter the jdk repo
    cd "$JDKDIR"

    # clone the rest of the tree, if needed
    if [ -f "./get_source.sh" ]; then
      echo "[FETCH] Downloading Java components"
      bash ./get_source.sh
    fi

    JAVA_VERSION="$(hg log -r "." --template "{latesttag}\n" | sed 's/jdk-//')-ev3"

  elif [ "$JAVA_SCM" == "hg_zip" ]; then
    cd "$BUILDDIR"

    # download bz2
    echo "[FETCH] Downloading Java tarball from Mercurial"

    set +e
    wget -nv -N "$JAVA_REPO"
    status=$?
    tries=1
    while [[ "$status" -ne "0" ]]; do

      if [[ "$tries" -gt "$TARBALL_MAX_DOWNLOADS" ]]; then
        echo "$TARBALL_MAX_DOWNLOADS download failed, giving up." 1>&2
        exit 1
      fi

      wget -nv -N "$JAVA_REPO"
      status=$?
      tries=$(($tries+1))
    done
    set -e

    # extract
    echo "[FETCH] Extracting tarball"
    mkdir "$JAVA_TMP"
    tar -C "$JAVA_TMP" -xf "$JAVA_BZ2"

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

  elif [ "$JAVA_SCM" == "git" ]; then
    latestTag="$($SCRIPTDIR/latest.awk "$JAVA_REPO")"
    JAVA_VERSION="$(echo "$latestTag" | sed 's/jdk-//')-ev3"

    # clone the root project
    echo "[FETCH] Cloning Java repo from Git"
    git clone --depth "1" --branch "$latestTag" "$JAVA_REPO" "$JDKDIR"

    # enter the jdk repo
    cd "$JDKDIR"
  fi

  echo "[FETCH] Java version string: $JAVA_VERSION"
  echo -e "#!/bin/bash\nJAVA_VERSION=\"$JAVA_VERSION\"" >"$BUILDDIR/jver.sh"

  # apply the EV3-specific patches
  echo "[FETCH] Patching the source tree"
  patch -p1 -i "$SCRIPTDIR/${PATCHVER}.patch"
  # debian library path
  patch -p1 -i "$SCRIPTDIR/${PATCHVER}_lib.patch"

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
