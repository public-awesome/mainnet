#/bin/sh
FILE=./check-gen-tx
DENOM=ustars
CHAIN_ID=stargaze-1
ONE_HOUR=3600
ONE_DAY=$(($ONE_HOUR * 24))
ONE_YEAR=$(($ONE_DAY * 365))
VALIDATOR_COINS=15000000000$DENOM


if [ -f "$FILE" ]; then
    starsd init validator --chain-id stargaze-1
    if [ "$1" == "mainnet" ]
    then
        LOCKUP=ONE_YEAR
    else
        LOCKUP=ONE_DAY
    fi
    echo "Lockup period is $LOCKUP"

    echo "Adding vesting accounts..."
    GENESIS_TIME=$(jq '.genesis_time' ~/.starsd/config/genesis.json | tr -d '"')
    echo "Genesis time is $GENESIS_TIME"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        GENESIS_UNIX_TIME=$(TZ=UTC gdate "+%s" -d $GENESIS_TIME)
    else
        GENESIS_UNIX_TIME=$(TZ=UTC date "+%s" -d $GENESIS_TIME)
    fi
    vesting_start_time=$(($GENESIS_UNIX_TIME + $LOCKUP))
    vesting_end_time=$(($vesting_start_time + $LOCKUP))

    sed -i 's#tcp://127.0.0.1:26657#tcp://0.0.0.0:26657#g' ~/.starsd/config/config.toml
    sed -i 's/stake/ustars/' ~/.starsd/config/genesis.json
    sed -i 's/pruning = "syncable"/pruning = "nothing"/g' ~/.starsd/config/app.toml
    wget https://github.com/MinseokOh/toml-cli/releases/download/v0.1.0-beta/toml-cli_0.1.0-beta_Linux_x86_64.tar.gz
    tar -xvf toml-cli_0.1.0-beta_Linux_x86_64.tar.gz 
    chmod +x ./toml-cli
    ./toml-cli set  ~/.starsd/config/app.toml api.enable true
    ./toml-cli set  ~/.starsd/config/app.toml rosetta.enable false
    mkdir -p ~/.starsd/config/gentx
    cp ./stargaze-1/pre-genesis.json ~/.starsd/config/genesis.json
    sed -i 's/2021-10-29T17:00:00Z/2021-10-25T17:00:00Z/' ~/.starsd/config/genesis.json
    echo "Processing validators..."
    for i in $CHAIN_ID/gentx/*.json; do
        cp $i ~/.starsd/config/gentx/
    done
    starsd collect-gentxs
    starsd validate-genesis
    starsd start
fi
