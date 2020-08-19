#!/bin/bash

set -eo pipefail

if [ "$(id -u)" != "0" ] ; then
	echo "Operation not permitted."
	exit 2
fi

# Hostname changing via SSH is reverted after reboot in Ubuntu 18.04. Make permanent change as following way.
sed -i "s/preserve_hostname: false/preserve_hostname: true/g" /etc/cloud/cloud.cfg

cur_hostname=$(cat /etc/hostname)
new_hostname=$1

echo $cur_hostname

if [ ! -n "$1" ] ; then
	new_hostname=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/' | sed "s/\./-/g")
fi

hostnamectl set-hostname $new_hostname
hostname $new_hostname

sudo sed -i "s/$cur_hostname/$new_hostname/g" /etc/hosts
sudo sed -i "s/$cur_hostname/$new_hostname/g" /etc/hostname

echo $new_hostname