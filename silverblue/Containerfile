FROM quay.io/fedora-ostree-desktops/silverblue:37
COPY etc /etc

# Enable RPM Fusion (thanks tony)
# Enable RPM Fusion and install it properly to avoid local override issues
RUN rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
rpm-ostree install rpmfusion-nonfree-release rpmfusion-free-release --uninstall=rpmfusion-free-release-$(rpm -E %fedora)-1.noarch --uninstall=rpmfusion-nonfree-release-$(rpm -E %fedora)-1.noarch

# uninstall gnome
# this prolly doesnt work
RUN rpm-ostree override remove @gnome-desktop

# leftwm install
RUN rpm-ostree install leftwm

RUN rpm-ostree cleanup -m && ostree container commit