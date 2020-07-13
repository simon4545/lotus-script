#!/usr/bin/env bash

set -euo pipefail

mkdir -p $HOME/log/lotus 

sudo cp -f lotus lotus-storage-miner lotus-seal-worker /usr/local/bin
sudo cp -f lotus-daemon.service /etc/systemd/system/lotus-daemon.service
sudo cp -f lotus-miner.service /etc/systemd/system/lotus-miner.service
sudo cp -f lotus-worker.service /etc/systemd/system/lotus-worker.service

systemctl daemon-reload
# systemctl start lotus-daemon
