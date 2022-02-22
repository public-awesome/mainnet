# v3.0.0 Upgrade

The upgrade is scheduled for block `1751919`, which should be about _05:30PM UTC on 24th February 2022_.

These instructions assume you are running Cosmovisor. Most mainnet validators are running Cosmovisor, and [a setup guide can be found here](https://docs.junonetwork.io/validators/setting-up-cosmovisor).

NOTE: Cosmovisor will preform a full backup unless `UNSAFE_SKIP_BACKUP=true` is set as an environment variable.

```bash
# get the new version (run inside the repo)
git checkout main && git pull
git checkout v3.0.0
make build && make install

# check the version - should be v3.0.0
# starsd version --long will be commit 62138d79f0b348449d5fb1e7838f9958842f879b
starsd version

# make a dir if you've not
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/v3/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/starsd $DAEMON_HOME/cosmovisor/upgrades/v3/bin

# find out what version you are about to run - should be v3.0.0
$DAEMON_HOME/cosmovisor/upgrades/v3/bin/starsd version
```

If you are not using Cosmovisor, then the chain will halt at the target height and you can manually switch over.

## Settings Recommendations

The following settings are recommended for application level `app.toml`, adjust based on your server specs.

```
# IavlCacheSize set the size of the iavl tree cache.
# Default cache size is 50mb.
#
iavl-cache-size=1562500


[wasm]
# Set the following if you have a public rpc endpoint
simulation_gas_limit=15000000

# This is the maximum sdk gas (wasm and storage) that we allow for any x/wasm "smart" queries
query_gas_limit = 100000

# MemoryCacheSize in MiB not bytes
memory_cache_size=100
```
