#!/usr/bin/env bash

set -eu

pushd $(west topdir)/bsim-demo/gatt-bug/central
central="$(pwd)/build/zephyr/zephyr.exe"
popd

pushd $(west topdir)/bsim-demo/gatt-bug/peripheral
peripheral="$(pwd)/build/zephyr/zephyr.exe"
popd

echo "Start PHY"
# Start the PHY
pushd "${BSIM_OUT_PATH}/bin"
./bs_2G4_phy_v1 -s=my-sim-id -D=3 &

echo "Slow down sim"
# Slow down the simulation: clamp speed to 10x real-time
pushd "${BSIM_COMPONENTS_PATH}/device_handbrake"
./bs_device_handbrake -s=my-sim-id -d=2 -r=10 &

echo "Start two devices"
# Start the two devices
$peripheral -s=my-sim-id -d=1 &
$central -s=my-sim-id -d=0
