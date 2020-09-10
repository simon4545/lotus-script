#!/usr/bin/env bash
#
# This is a Shell script for lotus.
#
# Reference URL:
# https://www.notion.so/134a172e369446018f5067097491550c

cur_dir="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
cur_date="$(date "+%m%d-%H")"

lotus_rep="https://github.com/filecoin-project/lotus.git"
branch="master"
commit="HEAD"
rep_dir="lotus-${branch}"

proxy="http://127.0.0.1:8000"

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
    sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
    _error_detect "apt-get -y --fix-broken install"
    _error_detect "apt-get -y update"
    _error_detect "apt-get -y install mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl"
    _error_detect "apt-get -y upgrade"
}

prepare_go() {
    _error_detect "curl -OL https://mirrors.nju.edu.cn/golang/go1.14.4.linux-amd64.tar.gz"
    _error_detect "tar -C /usr/local -xzf go1.14.4.linux-amd64.tar.gz"
    echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.profile
    source $HOME/.profile
}

prepare_rust() {
    export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
    export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
    _error_detect "curl -sSf https://sh.rustup.rs | sh -s -- -y"
    echo "source $HOME/.cargo/env" >> $HOME/.profile
    source $HOME/.profile
    cat > $HOME/.cargo/config <<EOF
    [source.crates-io]
    registry = "https://github.com/rust-lang/crates.io-index"
    replace-with = 'ustc'
    [source.ustc]
    registry = "git://mirrors.ustc.edu.cn/crates.io-index"
    EOF
}

# Make bin from source
make_bin() {
    source $HOME/.cargo/env
    export PATH=$PATH:/usr/local/go/bin
    git config --global http.proxy ${proxy}
    export GO111MODULE=on
    export GOPROXY=https://goproxy.cn,direct
    cd ${cur_dir}
    _error_detect "rm -rf ${rep_dir}"
    _error_detect "git clone --depth=1 -b ${branch} ${lotus_rep} ${rep_dir}"
    _error_detect "cd ${rep_dir}"
    _error_detect "git checkout ${commit}"
    _error_detect "git submodule init"
    _error_detect "git submodule update"
    sed -i 's/"check_cpu_for_feature": null/"check_cpu_for_feature": "sha_ni"/g' extern/filecoin-ffi/rust/rustc-target-features-optimized.json
    env RUSTFLAGS='-C target-cpu=native -g' FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1 FIL_PROOFS_USE_GPU_TREE_BUILDER=1 FFI_BUILD_FROM_SOURCE=1 make clean all lotus-bench
}

main() {
    _info "Prepare environment..."
    #prepare_apt
    #prepare_go
    #prepare_rust
    _info "Make lotus from source..."
    make_bin
    _info "Done!"
}

main "$@"