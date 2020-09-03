#!/bin/bash

set -eo pipefail

lotus_dir=/data1/lotus
proofs_dir=/data2/proofs/QmQG9NGWDUMb2WbAiGWkhT1WyZzSaYQQZBUgBxSbRXoqTt

bls=t3shkrtriftyb6oeglp5cu27nichu74kqy2ffqu3elmh4mzh24o6psbsdqdnbnagjq6i5i4urm5q3653krxnsq

export FIL_PROOFS_PARAMETER_CACHE=$proofs_dir
export FIL_PROOFS_MAXIMIZE_CACHING=1
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
export RUST_LOG=Trace

export TRUST_PARAMS=1

export LOTUS_PATH=$lotus_dir/daemon
export WORKER_PATH=$lotus_dir/worker

for i in {1..10};
do
    export LOTUS_STORAGE_PATH=$lotus_dir/miner-wallet-$i
    ./lotus-miner init --owner=$bls --sector-size=32GiB 2>&1 | tee wallet-$i.log
    miner_id=$(cat wallet-$i.log | grep "New miners address is" | awk '{print $9}')
    echo $miner_id >> wallet-list.log
done