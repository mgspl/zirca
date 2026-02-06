#!/bin/bash

set -xeuo pipefail

dnf -y install 'dnf5-command(config-manager)'

dnf config-manager setopt keepcache=1
trap 'dnf config-manager setopt keepcache=0' EXIT


# These were manually picked out from a Bluefin comparison with `rpm -qa --qf="%{NAME}\n" `
dnf -y install \
  -x PackageKit* \
  NetworkManager \
  NetworkManager-libnm \
  NetworkManager-ssh \
  NetworkManager-ssh-selinux \
  alsa-firmware \
  alsa-sof-firmware \
  alsa-tools-firmware \
  bootc \
  firewalld \
  flatpak \
  distrobox \
  fuse \
  fuse-common \
  fwupd \
  gum \
  gvfs-archive \
  gvfs-mtp \
  gvfs-nfs \
  gvfs-smb \
  jmtpfs \
  man-db \
  man-pages \
  plymouth \
  plymouth-system-theme \
  realtek-firmware \
  rsync \
  systemd-container \
  systemd-oomd-defaults \
  tuned \
  tuned-ppd \
  unzip \
  usb_modeswitch \
  zram-generator-defaults


if [ "$(rpm -E "%{fedora}")" == 43 ] ; then
  dnf -y copr enable ublue-os/flatpak-test
  dnf -y copr disable ublue-os/flatpak-test
  dnf -y --repo=copr:copr.fedorainfracloud.org:ublue-os:flatpak-test swap flatpak flatpak
  dnf -y --repo=copr:copr.fedorainfracloud.org:ublue-os:flatpak-test swap flatpak-libs flatpak-libs
  dnf -y --repo=copr:copr.fedorainfracloud.org:ublue-os:flatpak-test swap flatpak-session-helper flatpak-session-helper
  rpm -q flatpak --qf "%{NAME} %{VENDOR}\n" | grep ublue-os
fi
