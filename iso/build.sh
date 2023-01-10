#!/usr/bin/env bash
set -eux

if [ "$(whoami)" != "root" ]; then
	echo "Must be run as root"
	exit 1
fi

mkdir builddir && cd builddir

setenforce 0
mkdir -p repo cache
ostree --repo=repo init --mode=archive
rpm-ostree compose tree --unified-core --repo=repo --cachedir=cache ../fedora-silverblue.yaml

lorax -p Fedora -v 33 -r 33 \
	-s http://dl.fedoraproject.org/pub/fedora/linux/releases/33/Everything/x86_64/os/ \
	-s http://dl.fedoraproject.org/pub/fedora/linux/updates/33/x86_64/ \
	./resulsts/

#lorax  --product=Fedora \
#		--version=37 \
#		--release=20180410 \
#		--source=https://kojipkgs.fedoraproject.org/compose/37/latest-Fedora-37/compose/Everything/x86_64/os/ \
#		--variant=Silverblue \
#		--nomacboot \
#		--volid=Fedora-SB-ostree-x86_64-37 \
#		--add-template=$(pwd)/../lorax-configure-repo.tmpl \
#		--add-template=$(pwd)/../lorax-embed-repo.tmpl \
#		--add-template-var=ostree_install_repo=file://$(pwd)/repo \
#		--add-template-var=ostree_update_repo=file://$(pwd)/repo \
#		--add-template-var=ostree_osname=fedora \
#		--add-template-var=ostree_oskey=fedora-37-primary \
#		--add-template-var=ostree_contenturl=mirrorlist=https://ostree.fedoraproject.org/mirrorlist \
#		--add-template-var=ostree_install_ref=fedora/37/x86_64/silverblue \
#		--add-template-var=ostree_update_ref=fedora/37/x86_64/silverblue \
#		--logfile=$(pwd)/lorax.log \
#		--tmp=$(pwd)/tmp \
#		--rootfs-size=8 \
#		$(pwd)/ostree_installer
setenforce 1
cp ./ostree_installer/images/boot.iso ..
cd ..
rm -r builddir

