#!/bin/bash

set -xeuo pipefail

install -d /usr/share/zirconium/


install -Dpm0644 -t /usr/lib/pam.d/ /usr/share/quickshell/dms/assets/pam/* # Fixes long login times on fingerprint auth

sed --sandbox -i -e '/gnome_keyring.so/ s/-auth/auth/ ; /gnome_keyring.so/ s/-session/session/' /etc/pam.d/greetd


# keep in sync with zirconium preset file
systemctl preset greetd
systemctl preset --global chezmoi-init.service
systemctl preset --global chezmoi-update.timer
systemctl preset --global dms.service
systemctl preset --global gnome-keyring-daemon.service
systemctl preset --global gnome-keyring-daemon.socket
systemctl preset --global udiskie.service

install -Dpm0644 -t /usr/share/plymouth/themes/spinner/ /ctx/assets/logos/watermark.png
install -Dpm0644 -t /usr/share/zirconium/skel/Pictures/Wallpapers/ /ctx/assets/wallpapers/*
install -Dpm0644 -t /usr/share/zirconium/pixmaps/ /ctx/assets/logos/logo-z.svg

fc-cache --force --really-force --system-only --verbose # recreate font-cache to pick up the added fonts

echo 'source /usr/share/zirconium/shell/pure.bash' | tee -a "/etc/bashrc"

install -d /usr/share/bash-completion/completions
just --completions bash | sed -E 's/([\(_" ])just/\1zjust/g' > /usr/share/bash-completion/completions/zjust
