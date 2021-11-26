#!/bin/bash

sudo file -s /dev/nvme1n1
sudo mkdir /bkc-node
sudo mkfs -t ext4 /dev/nvme1n1
sudo mount /dev/nvme1n1 /bkc-node/
sudo chown -R $USER /bkc-node
sudo cp /etc/fstab /etc/fstab.bak

cd /bkc-node
df -h .

sudo echo "/dev/vdb       /bkc-node   ext4    defaults,nofail        0       0" >> /etc/fstab
sudo mount -a