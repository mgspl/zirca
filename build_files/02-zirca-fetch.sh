#!/bin/bash

set -ouex pipefail

### Install Kernel Cachyos (Stole From Piperita)
#dnf -y copr enable bieszczaders/kernel-cachyos-lto
#dnf -y copr disable bieszczaders/kernel-cachyos-lto
#dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-lto install \
#  kernel-cachyos-lto

dnf -y copr enable mgspl/zirca-packages 
dnf -y --enablerepo copr:copr.fedorainfracloud.org:mgspl:zirca-packages install \
  kernel


dnf -y copr enable bieszczaders/kernel-cachyos-addons
dnf -y copr disable bieszczaders/kernel-cachyos-addons
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons swap zram-generator-defaults cachyos-settings
dnf -y --enablerepo copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons install \
  scx-scheds-git \
  scx-manager

### Add mesa custom
dnf -y copr enable mgspl/zirca-packages 
dnf -y swap --repo=copr:copr.fedorainfracloud.org:mgspl:zirca-packages mesa-filesystem mesa-filesystem
### Add falcond
dnf -y install falcond falcond-profiles

### Add steam into base image
### I was using an container to install Steam but after an shower thinking its kinda dumb this image is to provide me an stable base
dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-steam.repo
dnf config-manager setopt fedora-steam.enabled=0
dnf -y  --setopt=install_weak_deps=False install --enablerepo=fedora-steam \
    -x PackageKit* \
    steam

### Install Lact
dnf -y copr enable ilyaz/LACT
dnf -y install lact
dnf -y copr disable ilyaz/LACT

### Install gpu-screen-recorder-ui
dnf -y copr enable brycensranch/gpu-screen-recorder-git
dnf -y --setopt=install_weak_deps=False install gpu-screen-recorder-ui
dnf -y copr disable brycensranch/gpu-screen-recorder-git

### Install Hblock
dnf -y copr enable pesader/hblock
dnf -y install hblock
systemctl enable hblock.timer
dnf -y copr disable pesader/hblock

### Cachy firefox settings
mkdir -p /usr/lib/firefox/browser/defaults/preferences/
curl -X 'GET' 'https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/refs/heads/master/cachyos-firefox-settings/cachyos.js' > /usr/lib/firefox/browser/defaults/preferences/cachyos.js
mkdir -p /etc/firefox/policies/
curl -X 'GET' 'https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/refs/heads/master/cachyos-firefox-settings/policies.json' > /etc/firefox/policies/policies.json

### Install packages from repos
dnf -y --setopt=install_weak_deps=False install \
	kitty 	\
	neovim   \
	openrgb	  \
	openrgb-udev-rules \
	adw-gtk3-theme \
	mangohud \
	goverlay \
	firefox

### Disable copr here
dnf -y copr disable mgspl/zirca-packages
