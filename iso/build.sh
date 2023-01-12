#!/usr/bin/env bash
set -eux

if [ "$(whoami)" != "root" ]; then
	echo "Must be run as root"
	exit 1
fi

setenforce 0
mkdir builddir && cd builddir

git clone -b f37 https://pagure.io/workstation-ostree-config.git
git clone -b f37 https://pagure.io/fedora-lorax-templates.git
mkdir -p repo cache
ostree --repo=repo init --mode=archive
rpm-ostree compose tree \
	--repo=$(pwd)/repo \
	--cachedir=$(pwd)/cache \
	$(pwd)/workstation-ostree-config/fedora-silverblue.yaml

lorax  --product=Fedora \
		--version=37 \
		--release=20180410 \
		--source=https://kojipkgs.fedoraproject.org/compose/37/latest-Fedora-37/compose/Everything/x86_64/os/ \
		--variant=Silverblue \
		--nomacboot \
		--volid=Fedora-SB-ostree-x86_64-37 \
		--add-template=$(pwd)/fedora-lorax-templates/ostree-based-installer/lorax-configure-repo.tmpl \
    	--add-template=$(pwd)/fedora-lorax-templates/ostree-based-installer/lorax-embed-repo.tmpl \
        --add-template=$(pwd)/fedora-lorax-templates/ostree-based-installer/lorax-embed-flatpaks.tmpl \
		--add-template-var=ostree_install_repo=file://$(pwd)/repo \
		--add-template-var=ostree_update_repo=file://$(pwd)/repo \
		--add-template-var=ostree_osname=fedora \
		--add-template-var=ostree_oskey=fedora-37-primary \
		--add-template-var=ostree_contenturl=mirrorlist=https://ostree.fedoraproject.org/mirrorlist \
		--add-template-var=ostree_install_ref=fedora/37/x86_64/silverblue \
		--add-template-var=ostree_update_ref=fedora/37/x86_64/silverblue \
		--add-template-var=flatpak_remote_name=fedora \
        --add-template-var=flatpak_remote_url=oci+https://registry.fedoraproject.org \
        --add-template-var=flatpak_remote_refs="runtime/org.fedoraproject.Platform/x86_64/f37 app/org.gnome.gedit/x86_64/stable" \
		--logfile=$(pwd)/lorax.log \
		--tmp=$(pwd)/tmp \
		--rootfs-size=8 \
		$(pwd)/ostree_installer
setenforce 1
mv ./ostree_installer/images/boot.iso ..
cd ..
rm -r builddir/ostree_installer

