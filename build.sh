#!/bin/sh
set -e
set -x

DEST="$1"
GCC="winegcc"
LIBS="-lmsvcrt"
CFLAGS="-m32 -Wall -O2"

case `uname` in
  CYGWIN*|MSYS*)
    GCC="gcc"
    LIBS=""
    CFLAGS="-Wall -O2"
    ;;
esac

if [ -z "$DEST" ]; then
	DEST=.
fi

"$GCC" $CFLAGS -o "$DEST/cl.exe" wrapmsvc.c -DWRAP_CL $LIBS
"$GCC" $CFLAGS -o "$DEST/link.exe" wrapmsvc.c -DWRAP_LINK $LIBS
"$GCC" $CFLAGS -o "$DEST/rc.exe" wrapmsvc.c -DWRAP_RC $LIBS
"$GCC" $CFLAGS -o "$DEST/mt.exe" wrapmsvc.c -DWRAP_MT $LIBS

if [ "$DEST" != "." ]; then
  ln -sf cl.exe "$DEST/cl.exe"
  ln -sf link.exe "$DEST/link.exe"
  ln -sf rc.exe "$DEST/rc.exe"
  ln -sf mt.exe "$DEST/mt.exe"
fi

