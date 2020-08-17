#!/bin/bash

set -eo pipefail

lotus_dir=/data1/lotus
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

ulimit -HSn 1048576

cp -r miner $lotus_dir

local_ip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/')

nohup ./lotus-worker run --listen ${local_ip}:2333 >> $log_dir/worker.log 2>&1 &