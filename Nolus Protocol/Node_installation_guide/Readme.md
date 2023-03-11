![nolus](https://user-images.githubusercontent.com/44331529/209941074-e137b77b-3d27-4e3d-a338-a773460b8a6c.png)
[WebSite](https://nolus.io) 
[GitHub](https://github.com/Nolus-Protocol/nolus-core) 
[Discord](https://discord.gg/nolus-protocol)
=

# RPC
```python
https://rpc.nolus-test.max-node.xyz/
```
# API
```python
https://api.nolus-test.max-node.xyz/
```
# gRpc
```python
https://grpc.nolus-test.max-node.xyz/
```

- **if you want to create RPC, API [HOW-TO-MAKE-RPC-API](https://github.com/Node-max/HOW-TO-MAKE-RPC-API)**


**Minimum hardware requirements**:

| Node Type |CPU | RAM  | Storage  | 
|-----------|----|------|----------|
| Testnet   |   4|  8GB | 150GB    |

# Server preparation

- **Updating packages**
```python
sudo apt update && sudo apt upgrade -y
```
- **Install developer tools and necessary packages**
```python
sudo apt install curl build-essential pkg-config libssl-dev git wget jq make gcc tmux chrony -y
```
- **Installing GO**
```python
wget https://go.dev/dl/go1.18.4.linux-amd64.tar.gz; \
rm -rv /usr/local/go; \
tar -C /usr/local -xzf go1.18.4.linux-amd64.tar.gz && \
rm -v go1.18.4.linux-amd64.tar.gz && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile && \
source ~/.bash_profile && \
go version
```
# Node installation

- **Clone the project repository with the node, go to the project folder and collect the binary files**
```python
cd $HOME 
git clone https://github.com/Nolus-Protocol/nolus-core 
cd nolus-core
git checkout v0.1.39
make install
```
- **Checking the version**
```python
nolusd version
#0.1.39
```
- **Creating Variables**
```python
MONIKER_NOLUS=type in your name
CHAIN_ID_NOLUS=nolus-rila
PORT_NOLUS=37
```
- **Save variables, reload .bash_profile and check variable values**
```python
echo "export MONIKER_NOLUS="${MONIKER_NOLUS}"" >> $HOME/.bash_profile
echo "export CHAIN_ID_NOLUS="${CHAIN_ID_NOLUS}"" >> $HOME/.bash_profile
echo "export PORT_NOLUS="${PORT_NOLUS}"" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo -e "\nmoniker_NOLUS > ${MONIKER_NOLUS}.\n"
echo -e "\nchain_id_NOLUS > ${CHAIN_ID_NOLUS}.\n"
echo -e "\nport_NOLUS > ${PORT_NOLUS}.\n"
```
- **Setting up the config**
```python
nolusd config chain-id $CHAIN_ID_NOLUS
nolusd config keyring-backend test
nolusd config node tcp://localhost:${PORT_NOLUS}657
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025unls\"/" $HOME/.nolus/config/app.toml
```
- **Initialize the node**
```python
nolusd init $MONIKER_NOLUS --chain-id $CHAIN_ID_NOLUS
```
- **Loading the genesis file and address book**
```python
wget https://raw.githubusercontent.com/Nolus-Protocol/nolus-networks/main/testnet/nolus-rila/genesis.json
mv ./genesis.json ~/.nolus/config/genesis.json
wget -O $HOME/.nolus/config/addrbook.json "https://raw.githubusercontent.com/sergiomateiko/addrbooks/main/nolus/addrbook.json"
```
- **Adding seeds and peers**
```python
seeds="" 
PEERS="$(curl -s "https://raw.githubusercontent.com/Nolus-Protocol/nolus-networks/main/testnet/nolus-rila/persistent_peers.txt")"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" ~/.nolus/config/config.toml
```
- **Setting up pruning**
```python
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nolus/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nolus/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nolus/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nolus/config/app.toml
```
- **Resetting data**
```python
nolusd tendermint unsafe-reset-all --home $HOME/.nolus
```
- **Create a service file**
```python
printf "[Unit]
Description=Nolus Service
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=$(which nolusd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/nolusd.service
```
- **Start the service and check the logs**
```python
sudo systemctl daemon-reload && \
sudo systemctl enable nolusd && \
sudo systemctl restart nolusd && \
sudo journalctl -u nolusd -f -o cat
```
- **We are waiting for the end of synchronization, you can check the synchronization with the command**
```python
nolusd status 2>&1 | jq .SyncInfo
```
If the output shows false, the sync is complete.

# State sync
```python
sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
nolusd tendermint unsafe-reset-all --home $HOME/.nolus

SNAP_RPC=http://rpc.nolus.ppnv.space:34657
SNAP_PEER=1a0bb6c35e2663202535d4b849ff06250762d299@rpc.nolus.ppnv.space:35656
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$(($LATEST_HEIGHT - 1000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -e "s|^enable *=.*|enable = true|" $HOME/.nolus/config/config.toml
sed -i.bak -e "s|^rpc_servers *=.*|rpc_servers = \"$SNAP_RPC,$SNAP_RPC\"|" $HOME/.nolus/config/config.toml
sed -i.bak -e "s|^trust_height *=.*|trust_height = $BLOCK_HEIGHT|" $HOME/.nolus/config/config.toml
sed -i.bak -e "s|^trust_hash *=.*|trust_hash = \"$TRUST_HASH\"|" $HOME/.nolus/config/config.toml

mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json
sudo systemctl restart nolusd && sudo journalctl -u nolusd -f -o cat
```

# Creating a wallet and validator

- **Create a wallet**
```python
nolusd keys add $MONIKER_NOLUS
```
Save the mnemonic phrase in a safe place!

If you participated in previous testnets, restore the wallet with the command and enter the mnemonic phrase
```python
nolusd keys add $MONIKER_NOLUS --recover
```
- **Create a variable with the address of the wallet and validator**
```python
WALLET_NOLUS=$(nolusd keys show $MONIKER_NOLUS -a)
VALOPER_NOLUS=$(nolusd keys show $MONIKER_NOLUS --bech val -a)

echo "export WALLET_NOLUS="${WALLET_NOLUS}"" >> $HOME/.bash_profile
echo "export VALOPER_NOLUS="${VALOPER_NOLUS}"" >> $HOME/.bash_profile
source $HOME/.bash_profile
echo -e "\nwallet_NOLUS > ${WALLET_NOLUS}.\n"
echo -e "\nvaloper_NOLUS > ${VALOPER_NOLUS}.\n"
```
To replenish the wallet with test tokens, go to the [Discord](https://discord.gg/nolus-protocol)  and request tokens in the testnet-faucet channel.

- **Checking your balance**
```python
nolusd q bank balances $WALLET_NOLUS
```
- **After the synchronization is completed and the wallet is replenished, we create a validator**
```python
nolusd tx staking create-validator \
--amount 1900000unls \
--from $WALLET_NOLUS \
--commission-rate "0.07" \
--commission-max-rate "0.20" \
--commission-max-change-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(nolusd tendermint show-validator) \
--moniker $MONIKER_NOLUS \
--chain-id "nolus-rila" \
--gas-prices 0.0042unls \
--identity="" \
--details="" \
--website="" \
-y
```

# Update
- **Stopping the node**
```python
sudo systemctl stop nolusd
```

- **Upgrading to v0.2.1-testnet**
```python
cd $HOME
rm -rf nolus-core
git clone https://github.com/Nolus-Protocol/nolus-core.git
cd nolus-core
git checkout v0.2.1-testnet
make build
```
```python
mkdir -p $HOME/.nolus/cosmovisor/upgrades/v0.2.1/bin
mv target/release/nolusd $HOME/.nolus/cosmovisor/upgrades/v0.2.1/bin/
rm -rf build
```
- **Checking the version**
```python
nolusd version 
```

## Non-Cosmovisor : 

UPGRADE AT BLOCK 1327000 !!!!

```python
cd $HOME
rm -rf nolus-core
git clone https://github.com/Nolus-Protocol/nolus-core.git
cd nolus-core
git checkout v0.2.1-testnet
make install
```

- **Restarting the node**
```python
sudo systemctl restart nolusd && sudo journalctl -u nolusd -f -o cat
```

# Deleting a node
- **Before deleting a node, make sure that the files from the /root/.nolus/config directory are saved
To remove a node, use the following commands**
```python
sudo systemctl stop nolusd
sudo systemctl disable nolusd
sudo rm -rf $HOME/.nolus
sudo rm -rf $HOME/nolus
sudo rm -rf /etc/systemd/system/nolusd.service
sudo rm -rf /usr/local/bin/nolusd
sudo systemctl daemon-reload
```

# Useful Commands
- **Node restart**
```python
sudo systemctl restart nolusd
```
- **Checking logs**
```python
sudo journalctl -u nolusd -f -o cat
```
- **Find out the address of the validator**
```python
nolusd keys show $MONIKER_NOLUS --bech val -a
```
- **Delegate tokens to validator**
```python
nolusd tx staking delegate nolusvaloper19qk8hgjvqaxrrv4f5l83dumq6th3uqvugxeyyy 90000000 --from $WALLET_NOLUS --chain-id $CHAIN_ID_NOLUS
```
- **Make changes to the validator**
```python
nolusd tx staking edit-validator --identity="" --details="" --website="" \
--from $WALLET_NOLUS --chain-id $CHAIN_ID_NOLUS -y
```
#identity - PGP key from keybase.io (sets validator avatar) \
#details - textual description of the validator





