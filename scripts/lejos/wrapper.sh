#!/bin/sh

ROOT="$(CDPATH= cd "$(dirname "$0")" && pwd)/.."
NAME="$(basename "$0")"

LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ROOT/sysroot/lib"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ROOT/sysroot/lib/arm-linux-gnueabi"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ROOT/sysroot/usr/lib"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ROOT/sysroot/usr/lib/arm-linux-gnueabi"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ROOT/sysroot/usr/lib/arm-linux-gnueabi/gconv"
export LD_LIBRARY_PATH
exec "$ROOT/sysroot/lib/ld-linux.so.3" --inhibit-cache "$ROOT/bin/$NAME.real" "$@"
