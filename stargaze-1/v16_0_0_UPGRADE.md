# v16.0.0 Upgrade

The upgrade is scheduled for block [19319579](https://www.mintscan.io/stargaze/block/19319579), which should be around _16:30 UTC on April 18th 2025_.

These instructions assume you are running Cosmovisor. Most mainnet validators are running Cosmovisor, and [a setup guide can be found here](https://docs.cosmos.network/v0.50/build/tooling/cosmovisor#installation).

NOTE: Cosmovisor will preform a full backup unless `UNSAFE_SKIP_BACKUP=true` is set as an environment variable.

### Go version

We recommend using go version 1.23.x which has the latest security updates.

### Build

```bash
# get the new version (run inside the repo)
git fetch origin --tags
git checkout v16.0.0
make build && make install

# check the version - should be v16.0.0
$HOME/go/bin/starsd version --long
> build_tags: netgo,ledger
> commit: 08a5ac1e53ba4935cb45c5390e9f23abf60654c8
> cosmos_sdk_version: v0.50.13
> go: go version go1.23.8
> name: stargaze
> server_name: starsd
> version: 16.0.0

# libwasmvm - 2.2.3
starsd  q wasm libwasmvm-version
> 2.2.3
# make a dir if you haven't
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/v16/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/starsd $DAEMON_HOME/cosmovisor/upgrades/v16/bin

# find out what version you are about to run - should be v16.0.0
$DAEMON_HOME/cosmovisor/upgrades/v16/bin/starsd version


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
