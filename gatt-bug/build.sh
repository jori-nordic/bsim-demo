#!/usr/bin/env bash

# Fail early if we have a build error
set -eu

# Build central image
pushd $(west topdir)/bsim-demo/gatt-bug/central
west build -b nrf52_bsim
popd

# Build peripheral image
pushd $(west topdir)/bsim-demo/gatt-bug/peripheral
west build -b nrf52_bsim
popd
