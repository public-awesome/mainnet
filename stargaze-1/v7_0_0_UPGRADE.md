# v7.0.0 Upgrade

The upgrade is scheduled for block `4448796`, which should be about _17:30 UTC on 30th August 2022_.

These instructions assume you are running Cosmovisor. Most mainnet validators are running Cosmovisor, and [a setup guide can be found here](https://docs.stargaze.zone/nodes-and-validators/setting-up-cosmovisor.

NOTE: Cosmovisor will preform a full backup unless `UNSAFE_SKIP_BACKUP=true` is set as an environment variable.

### Go version

We recommend using go version 1.18.5 which has the latest security updates.

### Build

```bash
# get the new version (run inside the repo)
git checkout main && git pull
git checkout v7.0.0
make build && make install

# check the version - should be v7.0.0
$HOME/go/bin/starsd version --long
> name: stargaze
> server_name: starsd
> version: 7.0.0
> commit: b0bea28fc695a2a5c567e56a37b289a5b75830cc
> build_tags: netgo,ledger
> go: go version go1.18 linux/amd64

# make a dir if you haven't
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/v7/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/starsd $DAEMON_HOME/cosmovisor/upgrades/v7/bin

# find out what version you are about to run - should be v7.0.0
$DAEMON_HOME/cosmovisor/upgrades/v7/bin/starsd version


```

If you are not using Cosmovisor, then the chain will halt at the target height and you can manually switch over.

## WARNING: WasmVM

If the binary was compiled on the same machine where it is going to run, check if it has linked the right version:

```bash
$> starsd q wasm libwasmvm-version
1.0.0
```

If you compile your binary on a different machine, pay extra attention to make sure you have the correct libwasm version

This will require manual intervention to avoid running on a different VM before the upgrade.

You can specify the path in the serviced file unit.

```
Environment="LD_LIBRARY_PATH=/root/libwasmvm/v1.0.0"
```

Verify that you don't have it in another path like `/usr/lib` or any other global paths.

### NOTE:

Having the incorrect version will cause a panic on startup and prevent the process from running
