.PHONY: generate

generate:
	rm -rf tmp/stargaze
	starsd init node --chain-id stargaze-1 --home tmp/stargaze --overwrite
	go run mainnet.go
	jq '.genesis_time="2021-10-29T17:00:00Z"' tmp/stargaze/config/genesis.json > stargaze-1/pre-genesis.json
ifeq ($(shell uname), Linux)
	sed -i 's/stake/ustars/' stargaze-1/pre-genesis.json
endif
ifeq ($(shell uname),Darwin)
	sed -i '' -e 's/stake/ustars/g' stargaze-1/pre-genesis.json
endif

ci-sign:
	drone sign public-awesome/mainnet --save  
run-local:
	sh ./scripts/local-network.sh
	cd tmp/local-testnet && docker-compose up
force-cleanup:
	sudo rm -rf tmp/
force-run-local: force-cleanup run-local

