# v10.0.0 Upgrade

The upgrade is scheduled for block `8576398`, which should be about _17:30 UTC on 8th June 2023_.

These instructions assume you are running Cosmovisor. Most mainnet validators are running Cosmovisor, and [a setup guide can be found here](https://docs.stargaze.zone/nodes-and-validators/setting-up-cosmovisor).

NOTE: Cosmovisor will preform a full backup unless `UNSAFE_SKIP_BACKUP=true` is set as an environment variable.

### Go version

We recommend using go version 1.20.4 which has the latest security updates.

### Build

```bash
# get the new version (run inside the repo)
git fetch origin --tags
git checkout v10.0.0
make build && make install

# check the version - should be v10.0.0
$HOME/go/bin/starsd version --long
> name: stargaze
> server_name: starsd
> version: 10.0.0
> commit: 6d4d6ba85c86bd412e91208753a092aca1e95460
> build_tags: netgo,ledger
> go: go version go1.20 linux/amd64

# make a dir if you haven't
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/v10/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/starsd $DAEMON_HOME/cosmovisor/upgrades/v10/bin

# find out what version you are about to run - should be v10.0.0
$DAEMON_HOME/cosmovisor/upgrades/v10/bin/starsd version


```

If you are not using Cosmovisor, then the chain will halt at the target height and you can manually switch over.

## WARNING: WasmVM

After the v10 upgrade automatically halts the chain remove the wasm cache located in `rm -rf ~/.starsd/wasm/wasm/cache` and start the node with the new version.

If you see the following error stop the node remove the cache and start the node again.

```
 fatal error: unexpected signal during runtime execution
May 30 20:53:59 s631 cosmovisor[115240]: [signal SIGSEGV: segmentation violation code=0x1 addr=0x7fd315131000 pc=0x7fd37c2d9cd0]
```
