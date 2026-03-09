# v18.0.0 Upgrade

The upgrade is scheduled for block [30758101](https://www.mintscan.io/stargaze/block/30758101), which should be around _14:00 UTC on March 12th 2026_.

These instructions assume you are running Cosmovisor. Most mainnet validators are running Cosmovisor, and [a setup guide can be found here](https://docs.cosmos.network/v0.50/build/tooling/cosmovisor#installation).

NOTE: Cosmovisor will preform a full backup unless `UNSAFE_SKIP_BACKUP=true` is set as an environment variable.

### Changes

- **Pauser module**: New module that allows pausing CosmWasm contract execution via governance or authorized addresses. Includes support for cron-based automation and CW hooks integration.
- **Dependency upgrades**:
  - CosmWasm/wasmd v0.54.1 -> v0.54.6
  - CosmWasm/wasmvm v2.2.4 -> v2.3.2
  - CometBFT v0.38.18 -> v0.38.21
  - Cosmos SDK v0.50.14 -> v0.50.15
  - IBC-Go v8.7.0 -> v8.8.0

### Go version

We recommend using go version 1.25.x which has the latest security updates.

### Build

```bash
# get the new version (run inside the repo)
git fetch origin --tags
git checkout v18.0.0
make build && make install

# check the version - should be v18.0.0
$HOME/go/bin/starsd version --long
> build_tags: netgo,ledger
> commit: a8c12be47b56e2b0f79fbe4557f7c4bc7e4c3600
> cosmos_sdk_version: v0.50.15
> go: go version go1.25.5
> name: stargaze
> server_name: starsd
> version: 18.0.0

# libwasmvm - 2.3.2
starsd  q wasm libwasmvm-version
> 2.3.2
# make a dir if you haven't
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/v18/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/starsd $DAEMON_HOME/cosmovisor/upgrades/v18/bin

# find out what version you are about to run - should be v18.0.0
$DAEMON_HOME/cosmovisor/upgrades/v18/bin/starsd version


```

If you are not using Cosmovisor, then the chain will halt at the target height and you can manually switch over.

### System Requirements

- At least 32GB RAM is recommended

If you don't have enough RAM available it is also recommended creating a swap file that can prevent potential OOM kills.

```bash
sudo fallocate -l 64G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```
