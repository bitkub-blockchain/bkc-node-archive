GETH_NODE=$(ls -1 | find geth)
if [ -z "$GETH_NODE" ]
    then
      geth --datadir . init ./*.json
      echo -e "\n[ Geth init successful! ]\n"
      wait
      read
fi
geth --datadir . --config ./config.toml
