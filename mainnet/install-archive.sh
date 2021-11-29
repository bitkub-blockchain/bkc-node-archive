#!/bin/bash

add-apt-repository -y ppa:ethereum/ethereum
apt-get update -y
apt-get install ethereum -y

mkdir -p /bkc-node/mainnet

curl https://raw.githubusercontent.com/bitkub-blockchain/bkc-node/next/mainnet/config.toml --output /bkc-node/mainnet/config.toml
curl https://raw.githubusercontent.com/bitkub-blockchain/bkc-node/next/mainnet/genesis.json --output /bkc-node/mainnet/genesis.json
curl https://raw.githubusercontent.com/bitkub-blockchain/bkc-node/next/mainnet/services/archive.service --output /etc/systemd/system/geth.service

geth --datadir /bkc-node/mainnet/data init /bkc-node/mainnet/genesis.json

systemctl daemon-reload
systemctl enable --now geth
systemctl restart geth

journalctl -u geth -f