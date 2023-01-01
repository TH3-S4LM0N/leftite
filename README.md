# LeftOS
Fedora Workstation based [LeftWM](https://github.com/leftwm/leftwm) distro. It's more akin to a Fedora Spin than a seperate OS, but having an [official spin](https://docs.fedoraproject.org/en-US/releases/spins/creating/) sounds horrible.

### Building
```bash
# install mock (replace with command appropriate for distro)
sudo dnf install mock

# if you're using selinux
sudo setenforce 0

sudo usermod -a -G mock <user>
mock -r ./fedora-37-x86_64.cfg --init
mock -r ./fedora-37-x86_64.cfg --install lorax-lmc-novirt vim-minimal pykickstart git
mock -r ./leftos-37-x86_64.cfg --shell --old-chroot --enable-network
git clone https://github.com/TH3-S4LM0N/leftos.git
cp leftos/leftos-37-x86_64.ks .
livemedia-creator --ks ./leftos-37-x86_64.ks --no-virt --resultdir /var/lmc --project LeftOS-37-x86_64 --make-iso --volid LeftOS-37-x86_64 --iso-only --iso-name LeftOS-37-x86_64.iso --releasever 37 --macboot
```
