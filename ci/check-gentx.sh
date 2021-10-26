#/bin/sh
FILE=./check-gen-tx
if [ -f "$FILE" ]; then
    echo "checking gentx collect"
    export FILE_LOCATION=$(cat check-gen-tx-file)
    starsd init validator
    mkdir -p ~/.starsd/config/gentx
    cp "./$FILE_LOCATION" ~/.starsd/config/gentx/
    export ADDRESS=$(cat check-gen-tx)
    cp ./stargaze-1/pre-genesis.json ~/.starsd/config/genesis.json
    starsd collect-gentxs
fi
