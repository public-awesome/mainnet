# v15.0.0 Upgrade

The upgrade is scheduled for block [17467937](https://www.mintscan.io/stargaze/block/17467937), which should be around _16:30 UTC on February 3rd 2025_.

These instructions assume you are running Cosmovisor. Most mainnet validators are running Cosmovisor, and [a setup guide can be found here](https://docs.cosmos.network/v0.50/build/tooling/cosmovisor#installation).

NOTE: Cosmovisor will preform a full backup unless `UNSAFE_SKIP_BACKUP=true` is set as an environment variable.

## IMPORTANT: PRE-UPGRADE REQUIRED

Pre-upgrade to v14.2.0-iavl-v1 is required to avoid minimal downtime during the upgrade if you have already performed these steps you can skip it.

To pre-upgrade, you can follow the instructions [here](https://publicawesome.notion.site/IAVL-V1-Snapshot-1837f04ea69680688c5ec278d144593a?pvs=4)

### Go version

We recommend using go version 1.23.0 which has the latest security updates.

### Build

```bash
# get the new version (run inside the repo)
git fetch origin --tags
git checkout v15.0.0
make build && make install

# check the version - should be v15.0.0
$HOME/go/bin/starsd version --long
> build_tags: netgo,ledger
> commit: de89f016aa2aafd99429688de836236311f7171e
> cosmos_sdk_version: v0.50.11
> go: go version go1.23.5
> name: stargaze
> server_name: starsd
> version: 15.0.0

# libwasmvm - 2.1.4
starsd  q wasm libwasmvm-version
> 2.1.4
# make a dir if you haven't
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/v15/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/starsd $DAEMON_HOME/cosmovisor/upgrades/v15/bin

# find out what version you are about to run - should be v15.0.0
$DAEMON_HOME/cosmovisor/upgrades/v15/bin/starsd version


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
