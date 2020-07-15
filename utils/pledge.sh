#!/bin/bash

set -o pipefail

while [ 1 ]; do
    workers=`./lotus-storage-miner sectors list | grep -E 'Commit|Sectors|Finalize' | wc -l`
    NOW=$(date '+%Y-%m-%d %H:%M:%S')

    if [ $? -ne 0 ]; then
        echo $NOW "Your miner is already exploded!"
    elif [ ${workers} -lt 12 ]; then
        echo $NOW "Add a sector."
        ./lotus-storage-miner sectors pledge
        sleep 15m
    else
        echo $NOW $workers "sectors in progress, do nothing."
    fi

    sleep 5m
done
