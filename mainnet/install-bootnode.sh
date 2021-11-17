#!/bin/bash

cd /bkc-node

add-apt-repository -y ppa:ethereum/ethereum
apt-get update -y
apt-get install ethereum git -y

chown -R $USER /bkc-node
git clone https://github.com/bitkub-blockchain/bkc-node.git .

cp ./mainnet/services/archive.service /etc/systemd/system/geth.service
sed -i "s/<NAME>/$1/g" /etc/systemd/system/geth.service;

geth --datadir /bkc-node/mainnet/data init /bkc-node/mainnet/genesis.json

systemctl daemon-reload
systemctl start geth

journalctl -u geth -f