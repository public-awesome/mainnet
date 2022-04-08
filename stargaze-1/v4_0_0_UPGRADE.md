# v4.0.0 Upgrade

The upgrade is scheduled for block `1751919`, which should be about _05:30PM UTC on 12th April 2022_.

These instructions assume you are running Cosmovisor. Most mainnet validators are running Cosmovisor, and [a setup guide can be found here](https://docs.stargaze.zone/nodes-and-validators/setting-up-cosmovisor.

NOTE: Cosmovisor will preform a full backup unless `UNSAFE_SKIP_BACKUP=true` is set as an environment variable.

```bash
# get the new version (run inside the repo)
git checkout main && git pull
git checkout v4.0.0
make build && make install

# check the version - should be v4.0.0
# starsd version --long will be commit [pending-commit-id]
$HOME/go/bin/starsd version

# make a dir if you've not
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/v4/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/starsd $DAEMON_HOME/cosmovisor/upgrades/v4/bin

# find out what version you are about to run - should be v4.0.0
$DAEMON_HOME/cosmovisor/upgrades/v4/bin/starsd version

```

If you are not using Cosmovisor, then the chain will halt at the target height and you can manually switch over.

## WARNING: WasmVM 

If the binary was compiled in the same machine where is going to run check it has linked the right version:
```bash
ldd $BINARY_LOCATION/bin/starsd | grep vm
>        libwasmvm.so => $HOME/go/pkg/mod/github.com/ !cosm!wasm/wasmvm@v1.0.0-beta10/api/libwasmvm.so (0x00007fadbf749000)

 ```


If you compile your binary in a different machine pay extra attention when doing to upgrade to have the correct libwasm version

This will require manual intervention to avoid running on a different vm before the upgrade.

You can specify the path in the serviced file unit.

```
Environment="LD_LIBRARY_PATH=/root/libwasmvm/beta10"
```

Verify that you don't have it in another path like `/usr/lib` or any other global paths.

Having the incorrect version may cause app hash differences.

## Settings Recommendations

The following settings are recommended for application level `app.toml`, adjust based on your server specs.

```
# IavlCacheSize set the size of the iavl tree cache.
# Default cache size is 50mb.
# Increased to 100mb
# iavl-cache-size = 3906250 for 32GB RAM or more
iavl-cache-size=1562500

[wasm]
# Set the following if you have a public rpc endpoint
simulation_gas_limit=50000000

# This is the maximum sdk gas (wasm and storage) that we allow for any x/wasm "smart" queries
query_gas_limit = 5000000

# MemoryCacheSize in MiB not bytes
memory_cache_size=1000
```
