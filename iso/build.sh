#!/usr/bin/env bash

mkdir -p repo cache
echo "Creating ostree repo"
ostree --repo=repo init --mode=archive
# unsure whether --unified-core is needed
echo "Composing tree"
sudo rpm-ostree compose tree --repo=repo --cachedir=cache fedora-silverblue.yaml
echo "Summarizing"
ostree summary --repo=repo --update