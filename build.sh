#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
echo $SCRIPTPATH

sb_prep() {
    mkdir -p $SCRIPTPATH/builddir
    cp -r $SCRIPTPATH/silverblue $SCRIPTPATH/builddir
    mkdir -p $SCRIPTPATH/builddir/usr/share/leftos
    cp -r $SCRIPTPATH/configs $SCRIPTPATH/builddir/usr/share/leftos
}

local_sb() {
    sb_prep
    podman build $SCRIPTPATH/builddir
}

while [[ "$1" ]]; do
    case $1 in
        "sb_prep") sb_prep ;;
        "local_sb") local_sb ;;
    esac

    shift
done

#rm -r ./builddir