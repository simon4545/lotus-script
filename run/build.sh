#!/bin/bash

set -eo pipefail

export proxy=http://127.0.0.1:8000
export http_proxy=$proxy
export https_proxy=$proxy
git config --global http.proxy $proxy
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct

source $HOME/.cargo/env
export PATH=$PATH:/usr/local/go/bin

git reset --hard origin/master

# sed -i 's/"check_cpu_for_feature": null/"check_cpu_for_feature": "sha_ni"/g' extern/filecoin-ffi/rust/rustc-target-features-optimized.json

env RUSTFLAGS='-C target-cpu=native -g' FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1 FIL_PROOFS_USE_GPU_TREE_BUILDER=1 FFI_BUILD_FROM_SOURCE=1 make clean all lotus-bench