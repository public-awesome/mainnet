#!/bin/bash
set -eux

export STARGAZE_HOME=$HOME/.starsd
export DENOM=ustars
export CHAIN_ID=stargaze-1

rm -rf $STARGAZE_HOME

starsd init moniker --chain-id stargaze-1
cp ./stargaze-1/pre-genesis.json $STARGAZE_HOME/config/genesis.json
wget https://s3.amazonaws.com/genesis.publicawesome.dev/snapshot.tar.gz
tar -xzvf snapshot.tar.gz

mkdir -p $STARGAZE_HOME/config/gentx

for i in $CHAIN_ID/gentx/*.json; do
    cp $i $STARGAZE_HOME/config/gentx/
done

# Prepare Genesis
starsd prepare-genesis mainnet stargaze-1 snapshot.json

starsd collect-gentxs > /dev/null 2>&1

echo $?

starsd validate-genesis
