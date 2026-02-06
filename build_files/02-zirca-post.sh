#!/bin/bash

set -ouex pipefail

systemctl enable openrgb
systemctl enable lactd

echo 'LANG=pt_BR.UTF-8' | tee -a "/etc/locale.conf"