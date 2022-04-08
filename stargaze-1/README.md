# Stargaze - Mainnet

![Stargaze](https://stargaze.zone/OGImage1200x630.png)

## _Genesis Start Time: October 29th at 17:00 UTC_

[Seed + peer list](https://hackmd.io/GRsY7WQVTVmIAjwznaKAMg)

**Genesis File**

Download the [genesis file](/stargaze-1/genesis.tar.gz):

```sh
curl -s  https://raw.githubusercontent.com/public-awesome/mainnet/main/stargaze-1/genesis.tar.gz > genesis.tar.gz
tar -C ~/.starsd/config/ -xvf genesis.tar.gz
```

**Genesis sha256**

```sh
jq -S -f normalize.jq  ~/.starsd/config/genesis.json | shasum -a 256

a8f1c085b48d1c62d3634f5d49cf2432ef7832fa2b629f6bd3feba20ee554475
```

**starsd version**

```sh
starsd version --long

name: stargaze
server_name: starsd
version: 1.0.0
commit: bee49997775a45f9f6383d6ba8c1dbc67439a6b6
```

_NOTE: If you had run an older binary previously, you might get a panic on start. If so, please start fresh with:_

```sh
starsd unsafe-reset-all
```

## Setup

**Prerequisites:** Make sure to have [Golang >=1.17](https://golang.org/).

### Build from source

You need to ensure your `GOPATH` configuration is correct. You might have to add these lines to your `.profile` or `.zshrc` if you don't have them already:

```bash
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
```

```bash
git clone https://github.com/public-awesome/stargaze
cd stargaze
git checkout v1.0.0
make install
```

This will build and install `starsd` binary into `$GOPATH\bin`.

Note: When building from source, it is important to have your `$GOPATH` set correctly. When in doubt, the following should do:

```bash
mkdir ~/go
export GOPATH=~/go
```

At the end, you should have a working `starsd` binary with the following version:

```sh
starsd version --long

name: stargaze
server_name: starsd
version: 1.0.0
commit: bee49997775a45f9f6383d6ba8c1dbc67439a6b6
```

### Minimum hardware requirements

- 8GB RAM
- 500GB of disk space
- 1.6 GHz AMD64 CPUs

## Setup validator node

Below are the instructions to generate and submit your genesis transaction.

### Generate genesis transaction (pre-launch only)

Only nodes that participated in the testnet will be able to validate. Others will be able to join the validator set at a later date after the chain launches.

1. Initialize the Stargaze directories and create the local genesis file with the correct
   chain-id

   ```bash
   starsd config chain-id stargaze-1
   starsd init <MONIKER-NAME> --chain-id stargaze-1
   ```

2. Create a local key pair (you should use the same key associated with you submitted for testnet rewards)

   ```bash
   starsd keys add <key-name>
   ```

   Note: if you're using an offline key for signing (for example, with a Ledger), do this with `starsd keys add <KEY-NAME> --pubkey <YOUR-PUBKEY>`. For the rest of the transactions, you will use the `--generate-only` flag and sign them offline with `starsd tx sign`.

3. Download the pre-genesis file:

   ```bash
   curl -s  https://raw.githubusercontent.com/public-awesome/mainnet/main/stargaze-1/pre-genesis.json >~/.starsd/config/genesis.json
   ```

   Find your account in the `stargaze-1/pre-genesis.json` file.

4. Create the gentx, replace `<KEY-NAME>`:

   ```bash
   starsd gentx <KEY-NAME> 10000000000ustars --commission-rate=0.05 --chain-id stargaze-1
   ```

   Note, amounts other than `10000000000ustars` will fail in CI, you will be able to delegate the remainder of your testnet rewards after chain start. Commission should be set to at least 5%

   If all goes well, you will see a message similar to the following:

   ```bash
   Genesis transaction written to "/home/[user]/.starsd/config/gentx/gentx-******.json"
   ```

### Submit genesis transaction

- Fork this repo into your Github account

- Clone your repo using:

  ```bash
  git clone https://github.com/<YOUR-GITHUB-USERNAME>/mainnet
  ```

- Copy the generated gentx json file to `<REPO-PATH>/stargaze-1/gentx/`

  ```bash
  cd mainnet
  cp ~/.starsd/config/gentx/gentx*.json ./stargaze-1/gentx/
  ```

- Commit and push to your repo
- Create a PR onto https://github.com/public-awesome/mainnet
- Only PRs from individuals / groups with a history successfully running validator nodes and that have initial STARS balance from the testnet will be accepted. This is to ensure the network successfully starts on time.

### Running in production

**Note, we'll be going through some upgrades soon after Stargaze mainnet. Consider using [Cosmovisor](https://docs.cosmos.network/master/run-node/cosmovisor.html) to make your life easier.**

[Cosmovisor quickstart](https://gist.github.com/bloqhub/ba04d09891bd59c21d9ff228eefadb62)

Download genesis file when the time is right. Put it in your `/home/<YOUR-USERNAME>/.starsd/config/` folder.

Create a `systemd` file for your Stargaze service:

```bash
sudo nano /etc/systemd/system/starsd.service
```

Copy and paste the following and update `<YOUR-USERNAME>`:

```bash
Description=Stargaze daemon
After=network-online.target

[Service]
User=<YOUR_USERNAME>
ExecStart=/home/<YOUR-USERNAME>/go/bin/starsd start
# If using Cosmovisor...
# ExecStart=/home/<YOUR-USERNAME>/go/bin/cosmovisor start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
```

**This assumes `$HOME/.starsd` to be your directory for config and data. Your actual directory locations may vary.**

Enable and start the new service:

```bash
sudo systemctl enable starsd
sudo systemctl start starsd
```

Check status:

```bash
starsd status
```

Check logs:

```bash
journalctl -u starsd -f
```

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

### Learn more

- [Stargaze Community Discord](https://discord.gg/QeJWCrE)
- [Stargaze Community Telegram](https://t.me/joinchat/ZQ95YmIn3AI0ODFh)
