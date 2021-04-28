#!/bin/bash
#  +---------------------------------------------------------------+
#  | This is validator-gen script. Note that before use make sure  |
#  | you have pre-requisite files, which are :                     |
#  |                    'genesis.json' <= For initialization.      |
#  |                    'startnode.sh' <= For generating script.   |
#  |                       /\     Need to have 'ADDR' as wallet    |
#  |                       |L____ by default. And 'EXTIP' for      |
#  | Enjoy.                '----- external IP address. (DIR added) |
#  +---------------------------------------------------------------+

# What this scripts can currently do :
#  - create node directory (depends on number of existing node dir)
#  - create account  (can specify password)
#  - use genesis.json to initialize created node dir (will delete current node if not existed)
#  - look for startnode.sh then replace the variables inside (can't change port yet)

#
# Color section.
#

RED='\033[0;31m' # Red
GRE='\033[0;32m' # Green
YEL='\033[1;33m' # Yellow
BLU='\033[0;34m' # Blue
NC='\033[0m' # No Color


#
# Function(s) are defined here.
#

dotsleep () {
  for ((i=1;i<="$1";i++))
  do
    echo -n ". "
    sleep 1s
  done
  echo -e "${GRE}Done!\n${NC}"
}

function reject.count.up {
 rejcount=$((rejcount+1))
}

#
# Variables.
#

num0=0;
node="";
path="";
pass="one";
pass2="two";
addr="";
skf="";
gene="";
#exip="";
import="";
ans="";
pvk="";
rejcount=0;
maxtries=2;
#
# Body of the script.
#

echo "+---------------------------------+"
echo "|  validator-gen.sh started.      |"
echo "+---------------------------------+"
echo -e "\n>> Making node directory..\n"

num0=$(file * | grep directory | grep node | wc -l)
node="node$num0"
path=$(pwd)

mkdir $node
echo "$node directory is successfully created. ( Under $path )"
echo -e "\n>> Creating account..\n"

echo "Do you wish to import account? (leave blank for \"no\")"
read import
if [ ! -z "$import" ]
  then
  while [[ -z "$pvk" ]]
  do
  ans="not_null"
  read -p "> Enter your private key : " pvk
  reject.count.up
  if [ "$rejcount" -gt "$maxtries" ]
    then
    echo -e "[ Maximum retries exceeded. Please try again. ]"
    exit
  fi
  done
fi
#
# Passwords section.
# ------------------
# Since passwords are pre-defined to be different. (refer to variable section)
# This 'while' loop will keep the commands running until the password is set
# correctly, whether it will be randomly generated (random strings 25 char long)
# or manually configured. Once done the password will be saved in node directory.
#

while [[ "$pass" != "$pass2" ]]
do
  if [ ! -z "ans" ]
  then
    ans0="not_null"
  else
  echo "Do you wish specify password? (leave blank for \"no\")"
  read ans0
  fi
  if [ -z "$ans0" ]
    then
    base64 -w 0 /dev/urandom | head -c 25 > $node/password.sec
    echo "Random password generated. ( $path/$node/password.sec )"
    pass2="one"
  else
    read -t 3000 -s -p "> Enter your password: " pass
    echo -n -e "\n"
    read -t 3000 -s -p "> Re-enter your password: " pass2
    if [ ! "$pass" = "$pass2" ]
    then
      echo -e "\n\n//////_ERROR_PASSWORD_MISMATCH!!!_//////\n"
    else
      echo "$pass" > $node/password.sec
      echo -e "\nPassword file generated. ( $path/$node/password.sec )"
    fi
  fi
  reject.count.up
  if [ "$rejcount" -gt "$maxtries" ]
  then
    echo -e "[ Maximum retries exceeded. Please try again. ]"
    exit
  fi
done
#
# Generating default account here.
# --------------------------------
# This section generates account using geth command and
# save the output into tempory file, then create another
# file that is properly configured.
#

if [ ! -z "$import" ]
then
  echo -e "\n>> Importing account..\n"
  mkdir output
  echo "$pvk" > output/pvk.tmp
  geth --datadir $node account import output/pvk.tmp --password $node/password.sec > output/$node.output
  dotsleep 3

  addr=$(cat output/$node.output | awk '{print $2}')
  addr=${addr:1}
  addr=${addr%?}
#  echo "Address is : $addr"
  path=$(pwd)
  skf=$(ls $path/node0/keystore/)
  echo -e "Public address: $addr\nSecret key path: $path/node0/keystore/$skf" > $node/acc$num0.txt
  echo -e "\n\n[$node/acc$num0.txt created.]"
  echo -e "\nPublic address: $addr\nSecret key path: $skf\n"
else
  echo -e "\n>> Generating account..\n"
  mkdir output
  geth --datadir $node account new --password $node/password.sec > output/$node.output
  dotsleep 3

  addr=$(grep Public output/$node.output | awk '{print $6}')
  skf=$(grep Path output/$node.output | awk '{print $7}')
  echo -e "Public address: $addr\nSecret key path: $skf" > $node/acc$num0.txt
  echo -e "\n\n[$node/acc$num0.txt created.]"
  echo -e "\nPublic address: $addr\nSecret key path: $skf\n"
fi

#
# Geth init here. (need 'genesis.json')
# -------------------------------------
# First 'if' was to check whether genesis.json exists or not.
# 'if' not it will echo out an error message (can be edited in the future)
#
# Once genesis.json is found, its content will be used in geth init and
# initialized the $node directory.
#

echo -e "\n>> Initialize $node with genesis file.."
gene=$(ls -1 | find genesis.json)
if [ -z "$gene" ]
  then
  echo -e "\n[${RED} !!!'genesis.json' not detected, please try again later.!!!${NC} ]  \n"  #<--------genesis.json error message
  rm -rf output && rm -rf $node
  wait
  exit
fi
dotsleep 3
geth --datadir $node init genesis.json
echo -e "\n[$node is initialized.]\n"

#
# Generating startnode script here. (need 'startnode' file)
# ---------------------------------------------------------
# Function the same as Geth init section. Once 'startnode' file is
# found, performed copy content into $node directory. Once done then
# proceed to replace the preset variable inside with this node vari-
# able. (To be more precise it's the address of newly created account)
#

echo -e "\nGenerating $node startnode.."
gene=$(ls -1 | find startnode.sh)
if [ -z "$gene" ]
  then
  echo -e "\n[${RED} !!!'startnode.sh' not detected, please try again later.!!!${NC} ]  \n"  #<--------startnode.sh error message
  rm -rf output && rm -rf $node
  wait
  exit
fi
dotsleep 3
echo -e "\nGetting external IP address..\n"
#exip=$(curl ifconfig.me)
#sed -e 's/\bEXIP\b/'"$exip"'/'
#sed -e 's/\bDIR\b/'"$path/$node/"'/' -e 's/\bADDR\b/'"$addr"'/' -e 's/\bpassword.txt\b/'"$path/"'password.sec/' startnode.sh > $path/$node/start$node.sh # Need startnode to have addr as account to be unlock
sed -e 's@\bDIR\b@'"$path/$node"'@' -e  's@\bADDR\b@'"$addr"'@' -e 's@\bpassword.txt\b@'"$path/"'password.sec@'  startnode.sh > $path/$node/start$node.sh

cat $node/start$node.sh
echo -e "\nstart$node.sh is generated under $path/$node/ \n"
chmod +x $node/start$node.sh
echo "[Program exited.]"

#
# Clear cache section.
# ---------------------
# This section was for various remove command;
# For testing purposes. (In case we need to run
# this code multiple times)

rm -rf output

# ^----remove output directory that was used
# to keep temporary file from creating account

#rm -rf $node



