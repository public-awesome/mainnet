#!/bin/bash
set -eux
export STARGAZE_HOME=tmp/full-test
export DENOM=ustars
export CHAIN_ID=stargaze-1
rm -rf tmp/
starsd init testmoniker --chain-id stargaze-1 --home $STARGAZE_HOME
cp ./stargaze-1/pre-genesis.json $STARGAZE_HOME/config/genesis.json
wget https://s3.amazonaws.com/genesis.publicawesome.dev/snapshot.tar.gz -P tmp/
tar -xzvf tmp/snapshot.tar.gz

mkdir -p $STARGAZE_HOME/config/gentx

# test actual gentxs
for i in $CHAIN_ID/gentx/*.json; do
    cp $i $STARGAZE_HOME/config/gentx/
done

# fake ci-testnet/gentxs
starsd testnet --v 4 --output-dir tmp/ci-testnet --chain-id stargaze-1 --initial-staking-amount 500000000000 --stake-denom ustars --coins 600000000000ustars

for i in tmp/ci-testnet/gentxs/*.json; do
    echo $i
    starsd add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) 600000000000ustars --home $STARGAZE_HOME
    cp $i $STARGAZE_HOME/config/gentx/
done
# Prepare Genesis
starsd prepare-genesis testnet stargaze-1 snapshot.json --home $STARGAZE_HOME

starsd collect-gentxs --home $STARGAZE_HOME > /dev/null 2>&1
echo $?
starsd validate-genesis --home $STARGAZE_HOME
i=0
while [ $i -ne 4 ]
do
    echo "$i"
    cp $STARGAZE_HOME/config/genesis.json "tmp/ci-testnet/node$i/starsd/config/"
    i=$(($i+1))
done
