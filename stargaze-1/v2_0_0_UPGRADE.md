# v2.0.0 Upgrade

The upgrade is scheduled for block `1317621`, which should be about _05:30PM UTC on 25th January 2022_.

These instructions assume you are running Cosmovisor. Most mainnet validators are running Cosmovisor, and [a setup guide can be found here](https://docs.stargaze.zone/nodes-and-validators/setting-up-cosmovisor).

NOTE: Cosmovisor will preform a full backup unless `UNSAFE_SKIP_BACKUP=true` is set as an environment variable.

```bash
# get the new version (run inside the repo)
git checkout main && git pull
git checkout v2.0.0
make build && make install

# check the version - should be v2.0.0
# starsd version --long will be commit 62138d79f0b348449d5fb1e7838f9958842f879b
starsd version

# make a dir if you've not
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/v2/bin

# if you are using cosmovisor you then need to copy this new binary
cp /home/<your-user>/go/bin/starsd $DAEMON_HOME/cosmovisor/upgrades/v2/bin

# find out what version you are about to run - should be v2.0.0
$DAEMON_HOME/cosmovisor/upgrades/v2/bin/starsd version
```

If you are not using Cosmovisor, then the chain will halt at the target height and you can manually switch over.
