# v14.0.0 Upgrade

The upgrade is scheduled for block [14252867](https://www.mintscan.io/stargaze/block/14252867), which should be around _14:30 UTC on 28th June 2024_.

These instructions assume you are running Cosmovisor. Most mainnet validators are running Cosmovisor, and [a setup guide can be found here](https://docs.cosmos.network/main/build/tooling/cosmovisor#installation).

NOTE: Cosmovisor will preform a full backup unless `UNSAFE_SKIP_BACKUP=true` is set as an environment variable.

### Go version

We recommend using go version 1.22.0 which has the latest security updates.

### Build

```bash
# get the new version (run inside the repo)
git fetch origin --tags
git checkout v14.0.0
make build && make install

# check the version - should be v14.0.0
$HOME/go/bin/starsd version --long
> name: stargaze
> server_name: starsd
> version: 14.0.0
> commit: 1bcda504836e85e4a5296d31524efaa5fd156b6c
> cosmos_sdk_version: v0.47.12
> build_tags: netgo,ledger
> go: go version go1.22.0 linux/amd64

# libwasmvm - 1.5.2
starsd  q wasm libwasmvm-version
> 1.5.2
# make a dir if you haven't
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/v14/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/starsd $DAEMON_HOME/cosmovisor/upgrades/v14/bin

# find out what version you are about to run - should be v14.0.0
$DAEMON_HOME/cosmovisor/upgrades/v14/bin/starsd version


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
