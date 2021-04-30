#! /bin/bash
#
# Description : This is a main script to run multiple smaller scripts to create running geth node
#
# v.0.0.2 includes geth-service scripts + node-check function

clear
version="v.0.0.2"

#
# Color section.
#

RED='\033[0;91m' # Red
GRE='\033[0;92m' # Green
YEL='\033[1;33m' # Yellow
BLU='\033[0;34m' # Blue
NC='\033[0m' # No Color
NOR='\033[0;39m'
DGRE='\033[0;32m'

# Function

function dotsleep () {
  for ((i=1;i<="$1";i++))
  do
    echo -e -n "${GRE}.  ${NC}"
    sleep 1s
  done
}

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

function ethis {
 echo -e "${GRE}$1${NOR}"
}
function ethis2 {
 echo -e "${DGRE}$1${NOR}"
}

#
# Bitkub Logo
#


ethis ""
ethis "  ____________       _______     ____________    ___         ____   ___       ___    ____________     "
ethis "  BBBBBBBBBBBBb.    dBBBBBBD    dBBBBBBBBBBBBb   KKKb       dBBP    UUU       UUU    BBBBBBBBBBBBb.   "
ethis "  BB           Vb      BN             BN         KKK|      dBB/      BN       BN     BB           Vb  "
ethis "  BB___________AP      BN             BN         KKK|     dBB/       BN       BN     BB           AP  "
ethis2 "  VVBBBBBBBBBVVK       BN             BN         VVVVVVVVVVVK        BN       BN     VVBBBBBBBBBBVK   "
ethis2 "  BB           Vb      BN             BN         KKK|     VBB\\       bY       Yd     BB           Vb  "
ethis2 "  BB___________AD    __BN___          BN         KKK|      VBB\\      VA       AV     BB___________AD    "
ethis2 "  BBBBBBBBBBBBBP'   dBBBBBBP          BB         KKK|       VBDb     'UUUUUUUUU'     BBBBBBBBBBBBBP'    "
ethis ""
echo -n " "
sleep 1
echo -e -n "${GRE}[ Press any key to continue... ]${NOR}"
read -n 1 -s
echo ""
sleep 1
clear


# Main
checkit
cp  bitkubchain.json genesis.json
echo -e "RUN THIS $version\n"
echo -e ">> running node-check" # Verifying existing node
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
