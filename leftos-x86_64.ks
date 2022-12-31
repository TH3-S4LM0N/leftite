# Maintained by the Fedora Workstation WG:
# http://fedoraproject.org/wiki/Workstation
# mailto:desktop@lists.fedoraproject.org

########################################
# start fedora-live-base.ks
# fedora-live-base.ks
#
# Defines the basics for all kickstarts in the fedora-live branch
# Does not include package selection (other then mandatory)
# Does not include localization packages or configuration
#
# Does includes "default" language configuration (kickstarts including
# this template can override these settings)

lang en_US.UTF-8
keyboard us
timezone US/Eastern
selinux --enforcing
firewall --enabled --service=mdns
xconfig --startxonboot
zerombr
clearpart --all
part / --size 5120 --fstype ext4
services --enabled=NetworkManager,ModemManager --disabled=sshd
network --bootproto=dhcp --device=link --activate
rootpw --lock --iscrypted locked
shutdown

###################################
# start fedora-repo.ks
# Include the appropriate repo definitions

# Exactly one of the following should be uncommented

# For the master branch the following should be uncommented
# %include fedora-repo-rawhide.ks

# For non-master branches the following should be uncommented
###################################
# start fedora-repo-not-rawhide.ks
repo --name=fedora --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch
#repo --name=updates-testing --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-testing-f$releasever&arch=$basearch
url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
# end fedora-repo-not-rawhide.ks
###################################

# end fedora-repo.ks
###################################


%packages
# Explicitly specified here:
# <notting> walters: because otherwise dependency loops cause yum issues.
kernel
kernel-modules
kernel-modules-extra

# The point of a live image is to install
anaconda
anaconda-install-env-deps
anaconda-live
@anaconda-tools
# Anaconda has a weak dep on this and we don't want it on livecds, see
# https://fedoraproject.org/wiki/Changes/RemoveDeviceMapperMultipathFromWorkstationLiveCD
-fcoe-utils
-device-mapper-multipath

# Need aajohan-comfortaa-fonts for the SVG rnotes images
aajohan-comfortaa-fonts

# Without this, initramfs generation during live image creation fails: #1242586
dracut-live

# anaconda needs the locales available to run for different locales
glibc-all-langpacks

# provide the livesys scripts
livesys-scripts
%end

%post
# Enable livesys services
systemctl enable livesys.service
systemctl enable livesys-late.service

# enable tmpfs for /tmp
systemctl enable tmp.mount

# make it so that we don't do writing to the overlay for things which
# are just tmpdirs/caches
# note https://bugzilla.redhat.com/show_bug.cgi?id=1135475
cat >> /etc/fstab << EOF
vartmp   /var/tmp    tmpfs   defaults   0  0
EOF

# work around for poor key import UI in PackageKit
rm -f /var/lib/rpm/__db*
echo "Packages within this LiveCD"
rpm -qa --qf '%{size}\t%{name}-%{version}-%{release}.%{arch}\n' |sort -rn
# Note that running rpm recreates the rpm db files which aren't needed or wanted
rm -f /var/lib/rpm/__db*

# go ahead and pre-make the man -k cache (#455968)
/usr/bin/mandb

# make sure there aren't core files lying around
rm -f /core*

# remove random seed, the newly installed instance should make it's own
rm -f /var/lib/systemd/random-seed

# convince readahead not to collect
# FIXME: for systemd

echo 'File created by kickstart. See systemd-update-done.service(8).' \
    | tee /etc/.updated >/var/.updated

# Drop the rescue kernel and initramfs, we don't need them on the live media itself.
# See bug 1317709
rm -f /boot/*-rescue*

# Disable network service here, as doing it in the services line
# fails due to RHBZ #1369794
systemctl disable network

# Remove machine-id on pre generated images
rm -f /etc/machine-id
touch /etc/machine-id

%end


%post --nochroot
# For livecd-creator builds only (lorax/livemedia-creator handles this directly)
if [ -n "$LIVE_ROOT" ]; then
    cp "$INSTALL_ROOT"/usr/share/licenses/*-release-common/* "$LIVE_ROOT/"

    # only installed on x86, x86_64
    if [ -f /usr/bin/livecd-iso-to-disk ]; then
        mkdir -p "$LIVE_ROOT/LiveOS"
        cp /usr/bin/livecd-iso-to-disk "$LIVE_ROOT/LiveOS"
    fi
fi

%end

# end fedora-live-base.ks
########################################
%include fedora-workstation-common.ks
#
# Disable this for now as packagekit is causing compose failures
# by leaving a gpg-agent around holding /dev/null open.
#
#include snippets/packagekit-cached-metadata.ks
 
part / --size 7750
 
%post
 
cat >> /etc/rc.d/init.d/livesys << EOF
 
 
# disable gnome-software automatically downloading updates
cat >> /usr/share/glib-2.0/schemas/org.gnome.software.gschema.override << FOE
[org.gnome.software]
allow-updates=false
download-updates=false
FOE
 
# don't autostart gnome-software session service
rm -f /etc/xdg/autostart/org.gnome.Software.desktop
 
# disable the gnome-software shell search provider
cat >> /usr/share/gnome-shell/search-providers/org.gnome.Software-search-provider.ini << FOE
DefaultDisabled=true
FOE
 
# don't run gnome-initial-setup
mkdir ~liveuser/.config
touch ~liveuser/.config/gnome-initial-setup-done
 
# suppress anaconda spokes redundant with gnome-initial-setup
cat >> /etc/sysconfig/anaconda << FOE
[NetworkSpoke]
visited=1
 
[PasswordSpoke]
visited=1
 
[UserSpoke]
visited=1
FOE
 
# make the installer show up
if [ -f /usr/share/applications/liveinst.desktop ]; then
  # Show harddisk install in shell dash
  sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop ""
  # need to move it to anaconda.desktop to make shell happy
  mv /usr/share/applications/liveinst.desktop /usr/share/applications/anaconda.desktop
 
  cat >> /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override << FOE
[org.gnome.shell]
favorite-apps=['firefox.desktop', 'org.gnome.Calendar.desktop', 'rhythmbox.desktop', 'org.gnome.Photos.desktop', 'org.gnome.Nautilus.desktop', 'anaconda.desktop']
FOE
 
  # Make the welcome screen show up
  if [ -f /usr/share/anaconda/gnome/fedora-welcome.desktop ]; then
    mkdir -p ~liveuser/.config/autostart
    cp /usr/share/anaconda/gnome/fedora-welcome.desktop /usr/share/applications/
    cp /usr/share/anaconda/gnome/fedora-welcome.desktop ~liveuser/.config/autostart/
  fi
 
  # Disable GNOME welcome tour so it doesn't overlap with Fedora welcome screen
  cat >> /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override << FOE
welcome-dialog-last-shown-version='4294967295'
FOE
 
  # Copy Anaconda branding in place
  if [ -d /usr/share/lorax/product/usr/share/anaconda ]; then
    cp -a /usr/share/lorax/product/* /
  fi
fi
 
# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas
 
# set up auto-login
cat > /etc/gdm/custom.conf << FOE
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser
FOE
 
# Turn off PackageKit-command-not-found while uninstalled
if [ -f /etc/PackageKit/CommandNotFound.conf ]; then
  sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf
fi
 
# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/
 
EOF
 
%end