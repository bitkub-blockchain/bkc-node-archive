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

stty -echoctl # hide ^C

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
 rej_count=$((rej_count+1))
}

function check.ifExist {
  CHECK_FILE=$(ls -1 | find "$1")
  if [ -z "$CHECK_FILE" ]
  then
    echo -e "\n[${RED} !!!'$1' not detected, please try again later.!!!${NC} ]  \n"  #<--------genesis.json e
    rm -rf output
    wait
    exit
  else
    echo -e "[${GRE} '$1' detected.${NC} ]  \n"
  fi
}

#
# Variables.
#

#NUM0=0;
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
rej_count=0;
max_tries=2;

# Trap
trap "rm -rfv output; read" EXIT

#
# Body of the script.
#

echo -e "\n>> Checking for prerequisite files\n"
check.ifExist "genesis.json"
check.ifExist "startnode.sh"
#check.ifExist
echo "+---------------------------------+"
echo "|  validator-gen.sh started.      |"
echo "+---------------------------------+"
#echo -e "\n>> Making node directory..\n"
#num0=$(file * | grep directory | grep node | wc -l)
node="validator-node"
path=$(pwd)

#mkdir $node
echo "$node directory is under $path."
echo -e "\n>> Creating account..\n"

echo "Do you wish to import account? (leave blank for \"no\")"
read import
if [ ! -z "$import" ] && [ "$import" != 'no' ]
  then
  while [[ -z "$pvk" ]]
  do
  ANS="not_null"
  read -p "> Enter your private key : " pvk
  reject.count.up
  if [ "$rej_count" -gt "$max_tries" ]
    then
    echo -e "[ Maximum retries exceeded. Please try again. ]"
    exit
  fi
  done
fi
echo ""

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
  if [ ! -z "$ans" ]
  then
    ans0="not_null"
  else
    echo "Do you wish specify password? (leave blank for \"no\")"
    read ans0
  fi
  if [ -z "$ans0" ] || [ "$ans0" == 'no' ]
    then
    base64 -w 0 /dev/urandom | head -c 25 > $path/password.sec
    echo "Random password generated. ( $path/password.sec )"
    pass2="one"
  else
    read -t 3000 -s -p "> Enter your password: " pass
    echo -n -e "\n"
    read -t 3000 -s -p "> Re-enter your password: " pass2
    if [ ! "$pass" = "$pass2" ]
    then
      echo -e "\n\n[${RED} _ERROR_PASSWORD_MISMATCH!!!_ ${NC}] ($rej_count/$max_tries)\n"
    else
      echo "$pass" > $path/password.sec
      echo -e "\nPassword file generated. ( $path/password.sec )"
    fi
  fi
  reject.count.up
  if [ "$rej_count" -gt "$max_tries" ]
  then
    echo -e "[ Maximum retries exceeded. Please try again. ]"
    wait
    read -p "Press any key to exit"
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

if [ ! -z "$import" ] && [ "$import" != 'no' ]
then
  echo -e "\n>> Importing account..\n"
  mkdir output
  echo "$pvk" > output/pvk.tmp
  geth --datadir $path account import output/pvk.tmp --password $path/password.sec > output/$node.output
  dotsleep 3

  addr=$(cat output/$node.output | awk '{print $2}')
  addr=${addr:1}
  addr=${addr%?}
  echo "Address is : $ADDR"
  path=$(pwd)
  skf=$(ls $path/keystore/)
  echo -e "Public address: $addr \nSecret key path: $path/keystore/$skf" > $path/acc.txt
  echo -e "\n\n[$path/acc.txt created.]"
  echo -e "\nPublic address: $addr\nSecret key path: $skf\n"
else
  echo -e "\n>> Generating account..\n"
  mkdir output
  geth --datadir $path account new --password $path/password.sec > $path/output/$node.output
  cat $path/output/$node.output

  dotsleep 3

  addr=$(grep Public output/$node.output | awk '{print $6}')
  skf=$(grep Path output/$node.output | awk '{print $7}')
  echo -e "Public address: $addr\nSecret key path: $skf" > $path/acc.txt
  echo -e "\n\n[$path/acc.txt created.]"
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
dotsleep 3
geth --datadir $path init genesis.json
echo -e "\n[$node is initialized.]\n"

#
# Generating startnode script here. (need 'startnode.sh' file)
# ---------------------------------------------------------
# Function the same as Geth init section. Once 'startnode.sh' file is
# found, performed copy content into $node directory. Once done then
# proceed to replace the preset variable inside with this node vari-
# able. (To be more precise it's the address of newly created account)
#

echo -e "\nGenerating $node start script.."
gene=$(ls -1 | find startnode.sh)
dotsleep 3
echo -e "\nGetting external IP address..\n"
#exip=$(curl ifconfig.me)
#sed -e 's/\bEXIP\b/'"$exip"'/'
#sed -e 's/\bDIR\b/'"$path/$node/"'/' -e 's/\bADDR\b/'"$addr"'/' -e 's/\bpassword.txt\b/'"$path/"'password.sec/' startnode.sh > $path/$node/start$node.sh # Need startnode to have addr as account to be unlock
sed -e 's@\bDIR\b@'"$path"'@' -e  's@\bADDR\b@'"$addr"'@' -e 's@\bpassword.txt\b@'"$path/"'password.sec@'  startnode.sh > $path/start.sh

cat $path/start.sh
echo -e "\nstart.sh is generated under $path \n"
chmod +x $path/start.sh
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



