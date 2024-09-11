#!/usr/bin/env bash

# It's ok if the FIFO already exists
set +eu

# The FIFO pair the python program uses to communicate with the Bluetooth
# controller device.
uart_h2c=/tmp/py/uart.h2c
uart_c2h=/tmp/py/uart.c2h

mkdir -p $(dirname ${uart_h2c})
mkfifo ${uart_h2c}
mkfifo ${uart_c2h}

# We don't want to execute if we have a build error
set -eu

this_dir=$(west topdir)/bsim-demo/python-demo

# Build controller image
pushd ${this_dir}/firmware/hci_sim
west build -b nrf52_bsim
popd

# Build scanner image
pushd ${this_dir}/firmware/observer
west build -b nrf52_bsim
popd

# Cleanup all existing sims
${BSIM_COMPONENTS_PATH}/common/stop_bsim.sh

# This talks to the python program
hci_uart="${this_dir}/firmware/hci_sim/build/zephyr/zephyr.exe"
$hci_uart \
    -s=python-id -d=1 -RealEncryption=0 -rs=70 \
    -fifo_0_rx=${uart_h2c} \
    -fifo_0_tx=${uart_c2h} &

# Start scanner
observer="${this_dir}/firmware/observer/build/zephyr/zephyr.exe"
$observer -s=python-id -d=2 -RealEncryption=0 -rs=70 &

# Force sim to (kinda) real-time
pushd "${BSIM_COMPONENTS_PATH}/device_handbrake"
./bs_device_handbrake -s=python-id -d=0 -r=10 &

echo "Starting simulation"

current_dir=$(pwd)

# Dump the packet trace when we stop (Ctrl-C) simulation
trap 'cleanup' INT

cleanup() {
    "${BSIM_OUT_PATH}"/components/ext_2G4_phy_v1/dump_post_process/csv2pcap \
        -o ${this_dir}/trace.pcap \
        "${BSIM_OUT_PATH}"/results/python-id/d_2G4*.Tx.csv
}

# Start the PHY
pushd "${BSIM_OUT_PATH}/bin"
./bs_2G4_phy_v1 -s=python-id -D=3 -dump_imm
