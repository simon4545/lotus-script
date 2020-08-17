#!/bin/bash

set -eo pipefail

lotus_dir=/data1/lotus
proofs_dir=/data1/proofs
log_dir=$HOME/log

mkdir -p $lotus_dir
mkdir -p $log_dir

export FIL_PROOFS_PARAMETER_CACHE=$proofs_dir
export RUST_LOG=Trace

export LOTUS_PATH=$lotus_dir/daemon
export LOTUS_STORAGE_PATH=$lotus_dir/miner
export WORKER_PATH=$lotus_dir/worker

ulimit -HSn 1048576

nohup lotus daemon >> $log_dir/daemon.log 2>&1 &