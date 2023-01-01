#!/usr/bin/env bash

mock -r ./leftos-37-x86_64.cfg --init
mock -r ./leftos-37-x86_64.cfg --install lorax-lmc-novirt vim-minimal pykickstart git
mock -r ./leftos-37-x86_64.cfg --shell --old-chroot --enable-network
