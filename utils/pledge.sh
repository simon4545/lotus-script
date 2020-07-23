#!/bin/bash

set -o pipefail

export LOTUS_PATH=/data2/lotus-calibration/daemon
export LOTUS_STORAGE_PATH=/data2/lotus-calibration/miner
export WORKER_PATH=/data2/lotus-calibration/worker
export FIL_PROOFS_PARAMETER_CACHE=/data2/proofs/v27

while [ 1 ]; do
    SECTORS=`./lotus-miner sectors list | grep -E 'Wait|Commit|Sectors|Finalize' | wc -l`
    ALL=``
    NOW=$(date '+%Y-%m-%d %H:%M:%S')

    if [ $? -ne 0 ]; then
        echo $NOW "Your miner is already exploded!"
    elif [ ${SECTORS} -lt 40 ]; then
        echo $NOW "Count:" $SECTORS "> Add a sector."
        ./lotus-miner sectors pledge
        # sleep 15m
    else
        echo $NOW "Count:" $SECTORS "> Do nothing."
    fi
    sleep 1m
done
