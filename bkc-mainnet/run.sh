#! /bin/bash
#
# Description : This is a main script to run multiple smaller scripts to create running geth node
#
# v.0.0.2 includes geth-service scripts + node-check function

clear
version="v.0.0.2"

# Function

#
# Color section.
#

RED='\033[0;31m' # Red
GRE='\033[0;32m' # Green
YEL='\033[1;33m' # Yellow
BLU='\033[0;34m' # Blue
NC='\033[0m' # No Color

# Function

function checkit {
  check=$(ls -1 | find node0)
  if [ ! -z "$check" ]
    then
    echo -e "\n[${RED} 'node0' dectected. ${NC}]  \n"
    echo -e "Program exited."
    wait
    exit
  fi
}

# Main
cp  bitkubchain.json genesis.json
echo -e "RUN THIS $version\n"
echo -e ">> running node-check" # Verifying existing node
checkit

echo -e ">> running geth-install.sh" # Verifying geth installation process
cp scripts/geth-install.sh ./geth-tmp.sh
./geth-tmp.sh
rm -rf geth-tmp.sh

echo -e ">> running validator-gen.sh"
cp scripts/validator-gen.sh ./va-gen.sh # Generate node
cp scripts/startnode.sh ./startnode.sh
./va-gen.sh
rm -rf va-gen.sh startnode.sh
echo -e ">> running geth-service.sh"
cp scripts/geth-service.sh ./geth-service.sh
./geth-service.sh
rm -rf geth-service.sh
echo -e "RUN THIS $version finished."
rm -rf genesis.json
