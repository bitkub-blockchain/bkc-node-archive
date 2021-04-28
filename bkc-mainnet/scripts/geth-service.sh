#! /bin/bash
#
# This scripts creates temporary geth.service then move to /etc/systemd/
# and then enable it
function  echoto {
  echo -e "$1" >> ./geth.temp
}

path=$(pwd)

echoto "[Unit]"
echoto "Description=Ethereum"
echoto ""
echoto "[Service]"
echoto "Type=simple"
echoto "ExecStart=/bin/bash $path/node0/startnode0.sh"
echoto "Restart=on-failure"
echoto "RestartSec=5s"
echoto ""
echoto "[Install]"
echoto "WantedBy=muli-user.target"

#=========================================

mv ./geth.temp /etc/systemd/system/geth.service
sudo systemctl daemon-reload
sudo systemctl enable geth.service
sudo systemctl start geth.service
#systemctl status geth.service

