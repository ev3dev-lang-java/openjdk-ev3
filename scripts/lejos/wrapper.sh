#!/bin/sh
DIR=`dirname "$0"`
DIR=`eval "cd \"$DIR\" && pwd"`
SYSDIR="$DIR/../sysroot"
SYSDIR=`eval "cd \"$SYSDIR\" && pwd"`

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SYSDIR/lib:$SYSDIR/lib/arm-linux-gnueabi:$SYSDIR/usr/lib:$SYSDIR/usr/lib/arm-linux-gnueabi:$SYSDIR/usr/lib/arm-linux-gnueabi/gconv"
exec "$SYSDIR/lib/ld-linux.so.3" "$DIR/$0.real" "$@"
