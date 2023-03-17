**RPC** \
https://rpc.source.max-node.xyz/ \
**API** \
https://api.source.max-node.xyz/ \
**gRpc** \
https://grpc.source.max-node.xyz/ 

- **Minimum hardware requirements**:

| Node Type |CPU | RAM  | Storage  | 
|-----------|----|------|----------|
| Testnet   |   4| 8GB  | 160GB    |

# Manual installation

wget -O sources https://raw.githubusercontent.com/Node-max/Testnet/main/Source%20Protocol/Node_installation_guide/auto_install_Source && chmod +x sources && ./sources



### Preparing the server
```python
sudo apt update && sudo apt upgrade -y && \
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y
```

## GO 19.4 (one command)
```python
cd $HOME && \
ver="1.19.4" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```

# Binary   01.08.22
```python 
git clone -b testnet https://github.com/Source-Protocol-Cosmos/source.git
cd ~/source
make install
```
`sourced version --long | head`
- version: v1.0.0-2-ge06b810
- commit: e06b810e842e57ec8f5432c9cdd57883a69b3cee 

## Initialisation
```python
sourced init <your name> --chain-id=sourcechain-testnet
```
## Add wallet
```python
sourced keys add <walletName>
    or
sourced keys add <walletName> --recover
```
# Genesis
```python
curl -s  https://raw.githubusercontent.com/Source-Protocol-Cosmos/testnets/master/sourcechain-testnet/genesis.json > ~/.source/config/genesis.json
```

`sha256sum $HOME/.source/config/genesis.json`
- 2bf556b50a2094f252e0aac75c8018a9d6c0a77ba64ce39811945087f6a5165d  genesis.json

### Pruning (optional) one command
```python
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.source/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.source/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.source/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.source/config/app.toml
```
### Indexer (optional) one command
```python
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.source/config/config.toml
```
### Set up the minimum gas price and Peers/Seeds/Filter peers
```python
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0usource\"/;" ~/.source/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.source/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.source/config/config.toml

peers="aad92fcdcba7855b9e815b038538532032004361@rpc.source.max-node.xyz:28657"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.source/config/config.toml

seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.source/config/config.toml

sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.source/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.source/config/config.toml
```

## Download addrbook
```python
wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/Node-max/Testnet/main/Source%20Protocol/Node_installation_guide/addrbook.json"
```

# Create a service file
```python
sudo tee /etc/systemd/system/sourced.service > /dev/null <<EOF
[Unit]
Description=source
After=network-online.target

[Service]
User=$USER
ExecStart=$(which sourced) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

# SnapShot (~0.1 GB) updated every 6 hours
```python
cd $HOME
apt install lz4
sudo systemctl stop sourced
cp $HOME/.source/data/priv_validator_state.json $HOME/.source/priv_validator_state.json.backup
rm -rf $HOME/.source/data
curl -o - -L https://snapshot.max-node.xyz/source//snapshot.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.source --strip-components 2
curl -o - -L https://snapshot.max-node.xyz/source/wasm/wasm-snap.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.source/data --strip-components 3
mv $HOME/.source/priv_validator_state.json.backup $HOME/.source/data/priv_validator_state.json
wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/Node-max/Testnet/main/Source%20Protocol/Node_installation_guide/addrbook.json"
sudo systemctl restart sourced && journalctl -u sourced -f -o cat
```

# Start node (one command)
```python
sudo systemctl daemon-reload &&
sudo systemctl enable sourced &&
sudo systemctl restart sourced && sudo journalctl -u sourced -f -o cat
```

## Create validator
```python
sourced tx staking create-validator \
--amount=1000000usource \
--pubkey=$(sourced tendermint show-validator) \
--moniker=<moniker> \
--chain-id=sourcechain-testnet \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.1" \
--min-self-delegation="1" \
--fees=100usource \
--from=<walletName> \
--identity="" \
--website="" \
--details="" \
-y
```

### Delete node (one command)
```python
sudo systemctl stop sourced && \
sudo systemctl disable sourced && \
rm /etc/systemd/system/sourced.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .source && \
rm -rf source && \
rm -rf $(which sourced)
```


