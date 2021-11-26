#!/bin/bash

cd /bkc-node

add-apt-repository -y ppa:ethereum/ethereum
apt-get update -y
apt-get install ethereum -y

mkdir -p /bkc-node/mainnet

curl https://raw.githubusercontent.com/bitkub-blockchain/bkc-node/x10/mainnet/config.toml --output /bkc-node/mainnet/config.toml
curl https://raw.githubusercontent.com/bitkub-blockchain/bkc-node/x10/mainnet/genesis.json --output /bkc-node/mainnet/genesis.json
curl https://raw.githubusercontent.com/bitkub-blockchain/bkc-node/x10/mainnet/services/bootnode.service --output /etc/systemd/system/geth.service

geth --datadir /bkc-node/mainnet/data init /bkc-node/mainnet/genesis.json

systemctl daemon-reload
systemctl enable --now geth
systemctl start geth

journalctl -u geth -f
