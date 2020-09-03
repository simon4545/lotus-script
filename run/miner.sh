#!/bin/bash

set -eo pipefail

lotus_dir=/nfs1/lotus
proofs_dir=/data1/proofs
log_dir=$HOME/log

mkdir -p $lotus_dir
mkdir -p $log_dir

export FIL_PROOFS_PARAMETER_CACHE=$proofs_dir
export FIL_PROOFS_MAXIMIZE_CACHING=1
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
export RUST_LOG=Trace

export TRUST_PARAMS=1

export LOTUS_PATH=$lotus_dir/daemon
export LOTUS_STORAGE_PATH=$lotus_dir/miner
export WORKER_PATH=$lotus_dir/worker

# export FIL_PROOFS_SDR_PARENTS_CACHE_SIZE=1073741824

ulimit -HSn 1048576

if [ ! -n "$1" ] ;then
    echo "Skip init."
else
    ./lotus-miner init --owner=$1 --sector-size=32GiB
fi

curl -OL https://raw.githubusercontent.com/aimkiray/lotus-script/master/config/miner.toml

local_ip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/')
public_ip=$(curl myip.ipip.net | awk '{print $2}' | awk -F： '{print $2}')

sed -i "s/local_ip/$local_ip/g" miner.toml
sed -i "s/public_ip/$public_ip/g" miner.toml

mv -f miner.toml $LOTUS_STORAGE_PATH/config.toml

nohup ./lotus-miner run >> $log_dir/miner.log 2>&1 &