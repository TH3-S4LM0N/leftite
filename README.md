# leftite
### **Not Complete, please do not use**
A [LeftWM](https://github.com/leftwm/leftwm) workstation for [Fedora Silverblue](https://silverblue.fedoraproject.org).

<!--
### Installation
```bash
rpm-ostree rebase --experimental ostree-unverified-registry:ghcr.io/th3-s4lm0n/leftite:latest
``` 


### Development
All building is done via GitHub Actions and [act](https://github.com/nektos/act).

##### Build ISO
The ISO cannot currently be built in a container (ex a github action). A actual Fedora machine must be run (can be a vm, tested with qemu/kvm)
```bash
git clone https://pagure.io/workstation-ostree-config && cd workstation-ostree-config
mkdir -p repo cache
ostree --repo=repo init --mode=archive
sudo rpm-ostree compose tree --repo=repo --cachedir=cache fedora-silverblue.yaml
ostree summary --repo=repo --update
```

### Credit where credit is due
I stole a lot of this from [here](https://github.com/cyrv6737/sb-custom), although he stole a lot from [Jorge Castro](https://github.com/castrojo) and he and [Kyle Gospo](https://github.com/kylegospo) taught me everything I know. \
Also thanks to spotify I like music.
-->

