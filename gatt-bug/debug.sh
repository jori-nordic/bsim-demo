#!/usr/bin/env bash

# We don't want to execute if we have a build error
set -eu

central="$(west topdir)/bsim-demo/gatt-bug/central/build/zephyr/zephyr.exe"
peripheral="$(west topdir)/bsim-demo/gatt-bug/peripheral/build/zephyr/zephyr.exe"

echo "Start PHY"
# Start the PHY
pushd "${BSIM_OUT_PATH}/bin"
./bs_2G4_phy_v1 -s=my-sim-id -D=3 &

echo "Slow down sim"
# Slow down the simulation: clamp speed to 10x real-time
pushd "${BSIM_COMPONENTS_PATH}/device_handbrake"
./bs_device_handbrake -s=my-sim-id -d=2 -r=10 &

echo "Start peripheral"
# Start the two devices
$peripheral -s=my-sim-id -d=1 &

echo "Start debug server on central device"
gdbserver :2345 $central -s=my-sim-id -d=0 &

# Give some time for server to start up
sleep 0.5
