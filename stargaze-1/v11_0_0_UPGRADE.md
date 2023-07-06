# v11.0.0 Upgrade

The upgrade is scheduled for block `9060226`, which should be about _15:30 UTC on 11th July 2023_.

These instructions assume you are running Cosmovisor. Most mainnet validators are running Cosmovisor, and [a setup guide can be found here](https://docs.stargaze.zone/nodes-and-validators/setting-up-cosmovisor).

NOTE: Cosmovisor will preform a full backup unless `UNSAFE_SKIP_BACKUP=true` is set as an environment variable.

### Go version

We recommend using go version 1.20.4 which has the latest security updates.

### Build

```bash
# get the new version (run inside the repo)
git fetch origin --tags
git checkout v11.0.0
make build && make install

# check the version - should be v11.0.0
$HOME/go/bin/starsd version --long
> name: stargaze
> server_name: starsd
> version: 11.0.0
> commit: c6741ba6800db3d4928ef3c4489f5480ac407df4
> build_tags: netgo,ledger
> go: go version go1.20.1 linux/amd64
> build_deps:

# make a dir if you haven't
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/v11/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/starsd $DAEMON_HOME/cosmovisor/upgrades/v11/bin

# find out what version you are about to run - should be v11.0.0
$DAEMON_HOME/cosmovisor/upgrades/v11/bin/starsd version


```

If you are not using Cosmovisor, then the chain will halt at the target height and you can manually switch over.
