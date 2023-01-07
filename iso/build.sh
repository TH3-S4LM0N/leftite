#!/usr/bin/env bash
set -eux

sudo setenforce 0
mkdir -p repo cache
ostree --repo=repo init --mode=archive
sudo rpm-ostree compose tree --unified-core --repo=repo --cachedir=cache fedora-silverblue.yaml
sudo lorax  --product=Fedora \
		--version=37 \
		--release=20180410 \
		--source=https://kojipkgs.fedoraproject.org/compose/37/latest-Fedora-37/compose/Everything/x86_64/os/ \
		--variant=Silverblue \
		--nomacboot \
		--volid=Fedora-SB-ostree-x86_64-37 \
		--add-template=$(pwd)/lorax-configure-repo.tmpl \
		--add-template=$(pwd)/lorax-embed-repo.tmpl \
		--add-template-var=ostree_install_repo=file://$(pwd)/repo \
		--add-template-var=ostree_update_repo=file://$(pwd)/repo \
		--add-template-var=ostree_osname=fedora \
		--add-template-var=ostree_oskey=fedora-37-primary \
		--add-template-var=ostree_contenturl=mirrorlist=https://ostree.fedoraproject.org/mirrorlist \
		--add-template-var=ostree_install_ref=fedora/37/x86_64/silverblue \
		--add-template-var=ostree_update_ref=fedora/37/x86_64/silverblue \
		--logfile=$(pwd)/lorax.log \
		--tmp=$(pwd)/tmp \
		--rootfs-size=8 \
		$(pwd)/ostree_installer
sudo setenforce 1
cp ./ostree_installer/images/boot.iso .

