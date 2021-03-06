#!/bin/bash
# SPDX-License-Identifier: LGPL-2.1-or-later
# Copyright © 2017-2018 ANSSI. All rights reserved.

# Safety settings: do not remove!
set -o errexit -o nounset -o pipefail

# The prelude to every script for this SDK. Do not remove it.
source /mnt/products/${CURRENT_SDK_PRODUCT}/${CURRENT_SDK_RECIPE}/scripts/prelude.sh

# Set systemd configuration
einfo "Set systemd configuration."
rm -rf "${CURRENT_OUT_ROOT}/etc/systemd/system"
install -o 0 -g 0 -m 0755 -d "${CURRENT_OUT_ROOT}/etc/systemd/system"
install -o 0 -g 0 -m 0755 -d "${CURRENT_OUT_ROOT}/etc/systemd/system/getty.target.wants"
install -o 0 -g 0 -m 0755 -d "${CURRENT_OUT_ROOT}/etc/systemd/system/multi-user.target.wants"
ln -s "/usr/lib/systemd/system/getty@.service" \
    "${CURRENT_OUT_ROOT}/etc/systemd/system/getty.target.wants/getty@tty1.service"
ln -s "/usr/lib/systemd/system/multi-user.target" \
    "${CURRENT_OUT_ROOT}/etc/systemd/system/default.target"

# Mask unneeded systemd user instances
rm "${CURRENT_OUT_ROOT}/lib64/systemd/system/user@.service"
ln -s '/dev/null' "${CURRENT_OUT_ROOT}/lib64/systemd/system/user@.service"

# Update /etc/systemd/journald.conf
sed -i 's|#Storage=auto|Storage=persistent|g' "${CURRENT_OUT_ROOT}/etc/systemd/journald.conf"
sed -i 's|#RateLimitBurst=1000|RateLimitBurst=2000|g' "${CURRENT_OUT_ROOT}/etc/systemd/journald.conf"

# vim: set ts=4 sts=4 sw=4 et ft=sh:
