#! /bin/bash
#
# This should be the first script to run, to make sure node additional node is made.
#

#
# Color section.
#

RED='\033[0;31m' # Red
GRE='\033[0;32m' # Green
YEL='\033[1;33m' # Yellow
BLU='\033[0;34m' # Blue
NC='\033[0m' # No Color

# Body

check=$(ls -1 | find node0)
if [ ! -z "$check" ]
  then
  echo -e "\n[${RED} 'node0' dectected. ${NC}]  \n"
  echo -e "Program exited."
  wait
  exit
fi
