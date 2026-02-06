#!/bin/bash

set -xeuo pipefail

dnf -y remove \
  console-login-helper-messages \
  sssd* \
  qemu-user-static* \
  toolbox