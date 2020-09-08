# 安装依赖
sudo apt update
sudo apt install -y mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl
sudo apt upgrade -y

# 安装 Go 和 Rust
curl -OL https://mirrors.nju.edu.cn/golang/go1.14.4.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.14.4.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.profile

export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
curl -sSf https://sh.rustup.rs | sh -s -- -y

echo "source $HOME/.cargo/env" >> $HOME/.profile

source $HOME/.profile

# 获取源码
git clone https://github.com/filecoin-project/lotus.git --depth=1 && cd lotus
git submodule init
git submodule update

# 编译 Lotus
cat > $HOME/.cargo/config <<EOF
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'
[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
EOF

export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct

env RUSTFLAGS='-C target-cpu=native -g' FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1 FIL_PROOFS_USE_GPU_TREE_BUILDER=1 FFI_BUILD_FROM_SOURCE=1 make clean all lotus-bench

export FIL_PROOFS_PARAMETER_CACHE=/data1/proofs
export IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/
./lotus fetch-params 32GiB

# AMD 机器可以跳过上面两步，下载预编译版本（下载地址请自行更新）
wget https://github.com/filecoin-project/lotus/releases/download/v0.5.3/lotus_v0.5.3_linux-amd64.tar.gz
tar -zxvf lotus_v0.5.3_linux-amd64.tar.gz

# 设置 256GB swap（128GB 内存需要设置，256GB 以上的跳过）
sudo fallocate -l 256G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile swap swap pri=50 0 0" >> /etc/fstab
sudo reboot

# 检查 swap 是否添加
swapon --show