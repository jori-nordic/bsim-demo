#!/usr/bin/env bash

set -eu

this_dir=$(west topdir)/bsim-demo/gatt-bug
sim_id=my-sim-id

"${BSIM_OUT_PATH}"/components/ext_2G4_phy_v1/dump_post_process/csv2pcap \
    -o ${this_dir}/trace.pcap \
    "${BSIM_OUT_PATH}"/results/${sim_id}/d_2G4*.Tx.csv
