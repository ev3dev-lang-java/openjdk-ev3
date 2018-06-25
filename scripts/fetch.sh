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
  patch -p1 -i "$SCRIPTDIR/$PATCHVER.patch"

else
  echo "[FETCH] Directory for JDK repository exists, assuming everything has been done already." 2>&1
fi


if [ ! -d "$SFLTDIR" ] && [ "$SFLT_NEEDED" == "true" ]; then
  # clone the root project
  echo "[FETCH] Cloning SoftFloat repo"
  git clone --depth 1 "$SFLTREPO" "$SFLTDIR"
fi
