# v13.0.0 Upgrade

The upgrade is scheduled for block [12801683](https://www.mintscan.io/stargaze/block/12801683), which should be around _14:30 UTC on 21th March 2024_.

These instructions assume you are running Cosmovisor. Most mainnet validators are running Cosmovisor, and [a setup guide can be found here](https://docs.stargaze.zone/nodes-and-validators/setting-up-cosmovisor).

NOTE: Cosmovisor will preform a full backup unless `UNSAFE_SKIP_BACKUP=true` is set as an environment variable.

### Go version

We recommend using go version 1.21.0 which has the latest security updates.

### Build

```bash
# get the new version (run inside the repo)
git fetch origin --tags
git checkout v13.0.0
make build && make install

# check the version - should be v13.0.0
$HOME/go/bin/starsd version --long
> name: stargaze
> server_name: starsd
> version: 13.0.0
> commit: 86894520383e40570e4d344fa8360bf33f37335d
> build_tags: netgo,ledger
> go: go version go1.21.0 linux/amd64

# libwasmvm - 1.5.2
starsd  q wasm libwasmvm-version
> 1.5.2
# make a dir if you haven't
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/v13/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/starsd $DAEMON_HOME/cosmovisor/upgrades/v13/bin

# find out what version you are about to run - should be v13.0.0
$DAEMON_HOME/cosmovisor/upgrades/v13/bin/starsd version


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
