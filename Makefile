.PHONY: generate

generate:
	rm -rf tmp/stargaze
	starsd init node --chain-id stargaze-1 --home tmp/stargaze --overwrite
	go run mainnet.go
	jq '.genesis_time="2021-10-29T17:00:00Z"' tmp/stargaze/config/genesis.json > stargaze-1/pre-genesis.json
	sed -i 's/stake/ustars/' stargaze-1/pre-genesis.json
