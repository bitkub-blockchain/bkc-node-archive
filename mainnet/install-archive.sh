#!/bin/bash

add-apt-repository -y ppa:ethereum/ethereum
apt-get update -y
apt-get install ethereum git -y

mkdir -p /bkc-node/mainnet
chown -R $USER /bkc-node

curl https://raw.githubusercontent.com/bitkub-blockchain/bkc-node/proen/mainnet/config.toml --output /bkc-node/mainnet/config.toml
curl https://raw.githubusercontent.com/bitkub-blockchain/bkc-node/proen/mainnet/genesis.json --output /bkc-node/mainnet/genesis.json
curl https://raw.githubusercontent.com/bitkub-blockchain/bkc-node/proen/mainnet/services/archive.service --output /etc/systemd/system/geth.service


sed -i "s/<NAME>/$1/g" /etc/systemd/system/geth.service;

geth --datadir /bkc-node/mainnet/data init /bkc-node/mainnet/genesis.json

systemctl daemon-reload
systemctl restart geth

journalctl -u geth -f