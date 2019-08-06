#!/bin/bash

SRCDIR=${1:-/tmp/BawtBuild/Linux/x64/Release/Install}
DSTDIR=${2:-/usr/local}

startdir=$(pwd)
cd "$SRCDIR"
for pkg in $(ls -1d *); do
    cd "$pkg"
    for d in bin include lib share man; do
        if [ -d "$d" ]; then
            cp -R "$d" "$DSTDIR"
        fi
    done
    cd ..
done
cd "$startdir"