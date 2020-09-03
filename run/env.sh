lotus_dir=/nfs1/lotus
proofs_dir=/data1/proofs

export FIL_PROOFS_PARAMETER_CACHE=$proofs_dir
export FIL_PROOFS_MAXIMIZE_CACHING=1
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
export RUST_LOG=Trace

export TRUST_PARAMS=1

export LOTUS_PATH=$lotus_dir/daemon
export LOTUS_STORAGE_PATH=$lotus_dir/miner
export WORKER_PATH=$lotus_dir/worker

iperf3 -c 183.134.100.62 -p 5201 -i 1 -t 30 -u -b 1000m