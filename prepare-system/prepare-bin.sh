#!/usr/bin/env bash
#
# This is a Shell script for lotus.
#
# Reference URL:
# https://www.notion.so/134a172e369446018f5067097491550c

cur_dir="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
cur_date="$(date "+%m%d-%H")"

lotus_rep="https://github.com/filecoin-project/lotus.git"
rep_dir="lotus-${cur_date}"
branch="ntwk-calibration"

proxy="http://192.168.0.8:8000"

_red() {
    printf '\033[1;31;31m%b\033[0m' "$1"
}

_green() {
    printf '\033[1;31;32m%b\033[0m' "$1"
}

_yellow() {
    printf '\033[1;31;33m%b\033[0m' "$1"
}

_printargs() {
    printf -- "%s" "[$(date)] "
    printf -- "%s" "$1"
    printf "\n"
}

_info() {
    _printargs "$@"
}

_warn() {
    printf -- "%s" "[$(date)] "
    _yellow "$1"
    printf "\n"
}

_error() {
    printf -- "%s" "[$(date)] "
    _red "$1"
    printf "\n"
    exit 2
}

_exit() {
    printf "\n"
    _red "$0 has been terminated."
    printf "\n"
    exit 1
}

_error_detect() {
    local cmd="$1"
    _info "${cmd}"
    eval ${cmd} 1> /dev/null
    if [ $? -ne 0 ]; then
        _error "Execution command (${cmd}) failed, please try again."
    fi
}

prepare_apt() {
    # sed -i 's/cn.archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
    _error_detect "apt-get -y update"
    _error_detect "apt-get -y install mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl"
    _error_detect "apt-get -y upgrade"
}

prepare_go() {
    export http_proxy=${proxy}
    export https_proxy=${proxy}
    export GO111MODULE=on
    export GOPROXY=https://goproxy.cn,direct
    _error_detect "curl -OL https://golang.org/dl/go1.14.4.linux-amd64.tar.gz"
    _error_detect "tar -C /usr/local -xzf go1.14.4.linux-amd64.tar.gz"
    echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.profile
    source $HOME/.profile
}

prepare_rust() {
    export http_proxy=${proxy}
    export https_proxy=${proxy}
    _error_detect "curl -sSf https://sh.rustup.rs | sh -s -- -y"
    source $HOME/.cargo/env
}

# Make bench from source
make_bench() {
    cd ${cur_dir}
    _error_detect "git clone -b ${branch} ${lotus_rep} ${rep_dir}"
    _error_detect "cd ${rep_dir}"
    _error_detect "git submodule init"
    _error_detect "git submodule update"
    sed -i 's/"check_cpu_for_feature": null/"check_cpu_for_feature": "sha_ni"/g' extern/filecoin-ffi/rust/rustc-target-features-optimized.json
    env RUSTFLAGS='-C target-cpu=native -g' FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1 FIL_PROOFS_USE_GPU_TREE_BUILDER=1 FFI_BUILD_FROM_SOURCE=1 make clean all lotus-bench
}

main() {
    _info "Prepare environment..."
    prepare_apt
    prepare_go
    prepare_rust
    _info "Make lotus from source..."
    make_bench
    _info "Done!"
}

main "$@"