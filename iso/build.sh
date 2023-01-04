#!/usr/bin/env bash

mkdir -p repo cache
ostree --repo=repo init --mode=archive
# unsure whether --unified-core is needed
sudo rpm-ostree compose tree --repo=repo --cachedir=cache fedora-silverblue.yaml
ostree summary --repo=repo --update