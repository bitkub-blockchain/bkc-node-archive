# Bitkub Chain Node

## Introduction
[Bitkub Chain](https://www.bitkubchain.com)  is an infrastructure of an ecosystem using decentralized technology “Blockchain” which allows anyone to interact with decentralized applications or their digital assets with a very low transaction fee, high-speed confirmation time, trustless and  transparency to everyone.

## Prerequisites
   - #### **Linux Instance**
        - ##### OS - Ubuntu version 18.04 
        - ##### Specifications
           - 4 vCPUs
           - 8 GiB of RAM
           - 1 TB of Disk
    
   - #### **Security Group / Firewall Rules** 
        - ##### Allow Inbound
          -  **Protocol** - TCP & UDP
          -  **Port** - 30303
          - **Source IP** - 0.0.0.0/0
                
## Installation Guide
#### 1. Clone Bitkub Chain Node github repo to your instance 
```shell
git clone https://github.com/bitkubchain/bkc-node -b node-script
```
#### 2. Switch to bkc-node/ directory
```shell
cd bkc-node/
```
#### 3.  Execute a script file name `install.sh` that use for setup all dependencies which requires before start a Bitkub Chain node.
```shell
./install.sh 
```
#### 4. Select Bitkub Chain Network that you want to run a node `Mainnet` or `Testnet` 
```shell
# Go to mainnet directory if you need to run a Bitkub Chain mainnet node
cd mainnet 

# Go to testnet directory if you need to run a Bitkub Chain testnet node
cd testnet 
```
#### 5. Choose between full-node or validator-node
 ```shell
# Go to full-node directory to run Bitkub Chain full node
cd full-node

# Go to validator-node directory to run Bitkub Chain validator node (need authorization)
cd validator-node 
```

## Starting Node Guide

### Running full-node

#### Simply execute the `run.sh` file to initialized current directory and start geth

 ```shell
./run.sh
```

### Running validator-node

#### 1) run `init.sh` to initialized current directory and complete account generation guide

 ```shell
./init.sh
```

#### 2) execute now generated `start.sh` to start geth (You can check your current account used in 'start.sh', or the generated account in 'acc.txt'.)

 ```shell
./start.sh
```
