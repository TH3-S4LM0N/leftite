#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
echo $SCRIPTPATH

mkdir -p $SCRIPTPATH/builddir
cp -r $SCRIPTPATH/silverblue $SCRIPTPATH/builddir
mkdir -p $SCRIPTPATH/builddir/usr/share/leftos
cp -r $SCRIPTPATH/configs $SCRIPTPATH/builddir/usr/share/leftos