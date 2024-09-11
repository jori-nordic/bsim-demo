#!/usr/bin/env bash
# Copyright (c) 2021 Nordic Semiconductor ASA
# SPDX-License-Identifier: Apache-2.0

set -eu

echo "Setting up environment"

export ZEPHYR_SDK_INSTALL_DIR="/opt/toolchains/zephyr-sdk-$( cat SDK_VERSION )"

# Skip if a workspace already exists
config_path="/workspaces/.west/config"
if [ -f "$config_path" ]; then
    echo "West .config exists, skipping init and update."
    exit 0
fi

# Can that have bad consequences if host UID != 1000?
sudo chown user:user /workspaces

# Set up west workspace.
west init -l /workspaces/bsim-demo
west config --global update.narrow true
west update

# Reset every project except the main zephyr repo.
#
# I can't "just" use $(pwd) or shell expansion as it will be expanded _before_
# the command is executed in every west project.
west forall -c 'pwd | xargs basename | xargs test "bsim-demo" != && git reset --hard HEAD' || true

echo "West initialized successfully"
