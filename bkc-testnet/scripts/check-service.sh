#! /bin/bash
output=$(ccze -V)
if [ -z "$output" ]; then
 echo -e "ccze is not installed!\n"
# echo -e "Checking for local installation."
# output=$(find /usr/local/ccze)
# if [ -z "$output" ]; then
#  echo "Local installation not found. Installing..."
 apt install ccze
# fi
fi
echo -e "Running check-service.sh...\b >> Press Ctrl+C to exit"
journalctl --follow -u geth.service | ccze


