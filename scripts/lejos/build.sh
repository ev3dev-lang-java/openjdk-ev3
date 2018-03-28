#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
source ../config.sh
SCRIPTDIR="$SCRIPTDIR/.."

pushd "$JDKDIR" >/dev/null
JAVA_VERSION="$(hg log -r "." --template "{latesttag}\n" | sed 's/jdk-//')"
popd
LEJOS_NAME="ejre-openjdk-$JAVA_VERSION"

# temp directory
rm -rf "$LEJOSDIR"
mkdir -p "$LEJOSDIR/deb" "$LEJOSDIR/root"

echo "copy in JRI"
cp -rf --preserve=links "$IMAGEDIR/jri-ev3" "$LEJOSDIR/jri"

echo "create version file ($JAVA_VERSION)"
echo "$JAVA_VERSION" >"$LEJOSDIR/jri/jrever"

echo "download DEB packages"
cd "$LEJOSDIR/deb"
apt-get download `cat "$SCRIPTDIR/lejos/pkgs.txt"`

echo "extract them"
find . -type f -exec dpkg-deb -x {} ../root \;

echo "remove unnecessary stuff"
cd "$LEJOSDIR/root"
rm -rf ./bin ./sbin ./etc ./usr/bin ./usr/sbin ./usr/share

echo "move root to jri"
mv "$LEJOSDIR/root" "$LEJOSDIR/jri/sysroot"

echo "install dynamic linking wrappers"
cd "$LEJOSDIR/jri/bin"

for exe in `ls`; do
  mv "$exe" "$exe.real"
  ln -s "wrapper.sh" "$exe"
done

cp "$SCRIPTDIR/lejos/wrapper.sh" .

echo "cleanup"
rm -rf "$LEJOSDIR/deb"

echo "create archive"
cd "$LEJOSDIR"
mv "jri" "$LEJOS_NAME"
tar -cf - "$LEJOS_NAME" | pigz -9 > "$BUILDDIR/$LEJOS_NAME.tar.gz"
