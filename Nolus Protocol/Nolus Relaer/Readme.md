# Guide Relayer Nolus-Rila(1837) - Osmosis(0)

## Install Hermes

```bash
curl -L#  https://github.com/informalsystems/hermes/releases/download/v1.2.0/hermes-v1.2.0-x86_64-unknown-linux-gnu.tar.gz | tar -xzf- -C /usr/local/bin
mkdir -p $HOME/.hermes
```

## Check Hermes

```bash
hermes version
```
should be something like this
```
2023-03-06T04:56:38.420498Z  INFO ThreadId(01) running Hermes v1.2.0+061f14f
hermes 1.2.0+061f14f
```

### If `glibc` Error (OPTIONAL)

```bash
sed -i '1i deb http://nova.clouds.archive.ubuntu.com/ubuntu/ jammy main' /etc/apt/sources.list

apt update && apt install libc6 -y

sed -i 's|deb http://nova.clouds.archive.ubuntu.com/ubuntu/ jammy.*||g' /etc/apt/sources.list

hermes version
```
### Enable Indexer
```
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.nolus/config/config.toml
sudo systemctl restart nolusd
```
### Set Config Hermes
```
nano $HOME/.hermes/config.toml
```
Fill with this configurations<br>
Replace 
`rpc_addr, 
grpc_addr,
websocket_addr,`
with your own node configuration

``memo_prefix = 'Relayed by Your_Moniker'`` Replace with your NODE NAME

```diff
# The global section has parameters that apply globally to the relayer operation.
[global]
log_level = 'info'

# Specify the mode to be used by the relayer. [Required]
[mode]

# Specify the client mode.
[mode.clients]
enabled = true
refresh = true
misbehaviour = false

# Specify the connections mode.
[mode.connections]
enabled = false

# Specify the channels mode.
[mode.channels]
enabled = false

# Specify the packets mode.
[mode.packets]
enabled = true
clear_interval = 100
clear_on_start = true
tx_confirmation = false

# The REST section defines parameters for Hermes' built-in RESTful API.
# https://hermes.informal.systems/rest.html
[rest]
enabled = true
host = '0.0.0.0'
port = 4000

[telemetry]
enabled = true
host = '0.0.0.0'
port = 4001



#################################################### OSMOSIS ###############################################################
[[chains]]
id = 'osmo-test-4'
rpc_addr = 'https://rpc-test.osmosis.zone'
grpc_addr = 'tcp://grpc-test.osmosis.zone:443'
websocket_addr = 'wss://rpc-test.osmosis.zone/websocket'

rpc_timeout = '10s'
account_prefix = 'osmo'
key_name = 'relayer'
store_prefix = 'ibc'
default_gas = 5000000
max_gas = 15000000
gas_price = { price = 0.0026, denom = 'uosmo' }
gas_multiplier = 1.1
max_msg_num = 20
max_tx_size = 209715
clock_drift = '20s'
max_block_time = '10s'
trusting_period = '10days'
memo_prefix = 'Relayed by Your_Moniker'
trust_threshold = { numerator = '1', denominator = '3' }

[chains.packet_filter]
policy = 'allow'
list = [
  ['transfer', 'channel-1837'], # nolus
]

###################################################### NOLUS ###############################################################
[[chains]]
id = 'nolus-rila'
rpc_addr = 'http://127.0.0.1:55657'
grpc_addr = 'http://127.0.0.1:55090'
websocket_addr = 'ws://127.0.0.1:55657/websocket'

rpc_timeout = '10s'
account_prefix = 'nolus'
key_name = 'relayer'
store_prefix = 'ibc'
default_gas = 1000000
max_gas = 4000000
gas_price = { price = 0.0025, denom = 'unls' }
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 2097152
clock_drift = '5s'
max_block_time = '30s'
trusting_period = '14days'
memo_prefix = 'Relayed by Your_Moniker'
trust_threshold = { numerator = '1', denominator = '3' }

[chains.packet_filter]
policy = 'allow'
list = [
  ['transfer', 'channel-0'], # Osmosis
]

```
## Check Health Hermes

```bash
hermes health-check
```
Should be like this

![image](https://user-images.githubusercontent.com/16186519/223024471-850626c5-1ffc-49bc-a8b1-6ebe556062d5.png)

## Wallet
### If you don't have a wallet, you can create one
```
nolusd keys add wallet_name
```
save your ``mnemonic phrase``

### If you already have, you can import here.

```bash
MNEMONIC="Your_mnemonic_or_Phrase"
```

```bash
echo "$MNEMONIC" > $HOME/.hermes.mnemonic
chain=('osmo-test-4' 'nolus-rila')
for c in ${chain[@]}; do
hermes keys add --key-name relayer --chain $c --mnemonic-file $HOME/.hermes.mnemonic
done
```
## Check Wallet Balance
```bash
for c in ${chain[@]}; do
hermes keys list --chain $c
hermes keys balance --chain $c
done
```

## Create hermes service

```bash
cat <<EOF > /etc/systemd/system/hermesd.service
[Unit]
Description="Hermes daemon"
After=network-online.target

[Service]
User=root
ExecStart=$(which hermes) start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

```

## Start hermesd

```bash
systemctl daemon-reload
systemctl enable hermesd
systemctl restart hermesd
```

## Check Logs
```bash
journalctl -ocat -fu hermesd
```

## Test IBC TRansfer
Sample Transaaction from Nolus-Rila(1837) to Osmosis(0)
```bash
hermes tx ft-transfer \
--src-chain nolus-rila \
--dst-chain osmo-test-4 \
--src-port transfer \
--src-channel channel-0 \
--key-name relayer \
--receiver address_osmosis \
--amount 1 \
--denom unls \
--timeout-seconds 60 \
--timeout-height-offset 180

```
Sample Transaaction from  Osmosis(0) to Nolus-Rila(1837)

```
hermes tx ft-transfer \
--src-chain osmo-test-4 \
--dst-chain nolus-rila \
--src-port transfer \
--src-channel channel-1837 \
--key-name relayer \
--receiver address_nolus \
--amount 1 \
--denom uosmo \
--timeout-seconds 60 \
--timeout-height-offset 180
```

