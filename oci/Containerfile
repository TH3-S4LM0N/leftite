FROM quay.io/fedora-ostree-desktops/silverblue:37

COPY etc /etc
COPY usr /usr

# Enable RPM Fusion (thanks tony)
RUN rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
rpm-ostree install rpmfusion-nonfree-release rpmfusion-free-release --uninstall=rpmfusion-free-release-$(rpm -E %fedora)-1.noarch --uninstall=rpmfusion-nonfree-release-$(rpm -E %fedora)-1.noarch

# uninstall gnome
# TO BE CLEAR:
# This for sure removes important packages and i will change this over time
RUN systemctl disable gdm
RUN rpm-ostree override remove mutter gdm gnome-bluetooth gnome-bluetooth-libs gnome-session-wayland-session NetworkManager-openconnect-gnome NetworkManager-openvpn-gnome NetworkManager-pptp-gnome gnome-session gnome-session-xsession gnome-control-center desktop-backgrounds-gnome f37-backgrounds-gnome gnome-themes-extra gnome-tour gnome-backgrounds gnome-classic-session gnome-settings-daemon gnome-shell gnome-shell-extension-background-logo gnome-shell-extension-common gnome-shell-extension-window-list gnome-software-rpm-ostree NetworkManager-adsl NetworkManager-ppp NetworkManager-ssh-gnome NetworkManager-vpnc-gnome evince-djvu fprintd-pam gnome-browser-connector gnome-disk-utility gnome-initial-setup gnome-software gnome-system-monitor gnome-terminal gnome-terminal-nautilus gnome-user-docs gnome-user-share gvfs-afp gvfs-archive gvfs-fuse gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb nautilus orca NetworkManager-openconnect NetworkManager-openvpn NetworkManager-pptp NetworkManager-ssh NetworkManager-vpnc apr apr-util apr-util-bdb apr-util-openssl brlapi brltty djvulibre-libs dotconf epiphany-runtime espeak-ng evince-libs evince-previewer evince-thumbnailer fedora-logos-httpd fprintd gnome-menus gnome-shell-extension-apps-menu gnome-shell-extension-launch-new-instance gnome-shell-extension-places-menu gspell httpd httpd-core httpd-filesystem httpd-tools julietaula-montserrat-fonts libXres libao libdazzle libfprint libgdata libportal libportal-gtk3 libportal-gtk4 libpskc libspectre libwnck3 mod_dnssd mod_http2 mod_lua nautilus-extensions openconnect openvpn pcaudiolib pcre2-utf32 pkcs11-helper ppp pptp python3-brlapi python3-louis python3-speechd redhat-menus speech-dispatcher speech-dispatcher-espeak-ng sshpass stoken-libs texlive-lib totem-video-thumbnailer trousers-lib vpnc vpnc-script vte-profile vte291 

# remove other non-gnome things
# RUN rpm-ostree override remove

# install everything 
RUN rpm-ostree install leftwm rofi feh alacritty dunst polybar picom fish sddm
RUN systemctl enable sddm

# install sddm theme
RUN mkdir -p /usr/share/sddm/themes
RUN cp -r /usr/share/leftite/configs/sddm-theme /usr/share/sddm/themes/leftite
RUN cp /usr/share/leftite/configs/sddm.conf /etc/sddm.conf.d

RUN rpm-ostree cleanup -m && ostree container commit