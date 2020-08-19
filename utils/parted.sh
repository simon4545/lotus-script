#!/bin/bash

set -eo pipefail

disk_name=${1:-"sda"}
mount_dir=${2:-"data1"}

# echo "mklabel GPT
# y
# mkpart primary 0% 100%
# quit
# " | parted /dev/$disk_name

parted -s /dev/$disk_name mklabel GPT
parted -s /dev/$disk_name mkpart primary 0% 100%

mkfs.ext4 /dev/${disk_name}1

mkdir /$mount_dir -p

echo "/dev/${disk_name}1 /$mount_dir ext4 defaults 0 0" >> /etc/fstab
mount /dev/${disk_name}1 /$mount_dir