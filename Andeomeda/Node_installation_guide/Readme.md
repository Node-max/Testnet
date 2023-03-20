# Andromeda_testnet
![Image alt](https://github.com/Node-max/HOW-TO-MAKE-RPC-API/blob/main/foto/mmWl_G3q.jpg)

# [WebSite](https://andromedaprotocol.io/) 
# [GitHub](https://github.com/andromedaprotocol) 
# [Discord](https://discord.gg/fnfwb3SJ)

# API
```python
https://api.andromeda-test.max-node.xyz/
```

# RPC
```python
https://rpc.andromeda-test.max-node.xyz/
```
- **if you want to create RPC, API [HOW-TO-MAKE-RPC-API](https://github.com/Node-max/HOW-TO-MAKE-RPC-API)**


**Minimum hardware requirements**:

| Node Type |CPU | RAM  | Storage  | 
|-----------|----|------|----------|
| Testnet   |   4|  8GB | 150GB    |

# Server preparation
```python
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

# Installing GO 1.19:
```python
ver="1.19" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```

# Node installation. Build 12.02.23:
```python
cd $HOME
git clone https://github.com/andromedaprotocol/andromedad.git
cd andromedad
git checkout galileo-3-v1.1.0-beta1 
make install
```
- **Checking the version**
```python
andromedad version --long
```
**version: galileo-3-v1.1.0-beta1** \
**commit: b3f8d880dfcdb3265d321e465b47b04071d9480f**
```python
andromedad init cryptobhartiya --chain-id galileo-3
andromedad config chain-id galileo-3
```

- **Create or recover wallet:**
```python
andromedad keys add <walletname>
  OR
andromedad keys add <walletname> --recover
```
To replenish the wallet with test tokens, go to the [Discord](https://discord.gg/fnfwb3SJ)  and request tokens in the testnet-faucet channel.

- **Check Balance:**
```python
andromedad query bank balances andr1rnqef6w..........hrdpyscqh2jx64p3xgc
```

- **Download Genesis:**
```python
git clone https://github.com/andromedaprotocol/testnets
cd testnets
cp genesis.json $HOME/.andromedad/config
```
```python
sha256sum $HOME/.andromedad/config/genesis.json
```
**29ad5850ed21e01416b5df103653d4380570380e61183770c5eaee5681b7bde2 /root/.andromedad/config/genesis.json**

- **Set up the minimum gas price and Peers/Seeds/Filter peers/MaxPeers:**
```python
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0uandr\"/;" ~/.andromedad/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.andromedad/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.andromedad/config/config.toml
peers="06d4ab2369406136c00a839efc30ea5df9acaf11@10.128.0.44:26656,43d667323445c8f4d450d5d5352f499fa04839a8@192.168.0.237:26656,29a9c5bfb54343d25c89d7119fade8b18201c503@192.168.101.79:26656,6006190d5a3a9686bbcce26abc79c7f3f868f43a@37.252.184.230:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.andromedad/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.andromedad/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.andromedad/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.andromedad/config/config.toml
```

- **Pruning (optional):**
```python
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.andromedad/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.andromedad/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.andromedad/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.andromedad/config/app.toml
```
- **Indexer (optional):*
```python
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.andromedad/config/config.toml
```

- **Download addrbook:**
```python
wget -O $HOME/.andromedad/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/AndromedaProtocol/addrbook.json"
```
- **Create a service file:**
```python
sudo tee /etc/systemd/system/andromedad.service > /dev/null <<EOF
[Unit]
Description=andromedad
After=network-online.target

[Service]
User=$USER
ExecStart=$(which andromedad) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

- **StateSync Andromedad Testnet:**
**Copy the entire command**
```python
sudo systemctl stop andromedad
SNAP_RPC="https://rpc.andromeda.node-max.space"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.andromedad/config/config.toml

peers="297a09dd5d004cf36ce844bd0049756a83ab54cd@rpc.andromeda.node-max.space:26656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.andromedad/config/config.toml 

andromedad tendermint unsafe-reset-all --home ~/.andromedad --keep-addr-book && sudo systemctl restart andromedad && \
journalctl -u andromedad -f --output cat
```
**Turn off State Sync Mode after synchronization**
```python
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.andromedad/config/config.toml
```

- **Stop Andromeda**
```pyton
sudo systemctl stop andromedad
```
- **Download latest snapshot**
```pyton
cp $HOME/.andromedad/data/priv_validator_state.json $HOME/.andromedad/priv_validator_state.json.backup
curl https://snapshot.andromeda.max-node.xyz/andromeda/andromeda-snapshot-20230303.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.andromedad
```
```pyton
mv $HOME/.andromedad/priv_validator_state.json.backup $HOME/.andromedad/data/priv_validator_state.json 
```

- **Restart the service and check the log**
```pyton
sudo systemctl start andromedad
sudo journalctl -u andromedad -f --no-hostname -o cat
```

- **Start the service and check the logs**
```python
sudo systemctl daemon-reload
sudo systemctl enable andromedad
sudo systemctl restart andromedad && sudo journalctl -u andromedad -f -o cat
```
- **We are waiting for the end of synchronization, you can check the synchronization with the command**
```python
andromedad status 2>&1 | jq .SyncInfo
```
If the output shows **false**, the sync is complete.

- **Delete node:*
```python
sudo systemctl stop andromedad && \
sudo systemctl disable andromedad && \
rm /etc/systemd/system/andromedad.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf andromedad && \
rm -rf .andromedad && \
rm -rf $(which andromedad)
```

- **Create validator:**
```python
andromedad tx staking create-validator \
--commission-rate 0.1 \
--commission-max-rate 1 \
--commission-max-change-rate 1 \
--min-self-delegation "1" \
--amount 1000000uandr \
--pubkey $(andromedad tendermint show-validator) \
--from <wallet> \
--moniker="AndroValin" \
--chain-id galileo-3 \
--gas 350000 \
--identity="" \
--website="" \
--details="" -y
```

- **Delegate tokens to validator**
```python
andromedad tx staking delegate andrvaloper1rnqef6wz6g3dv0dg34jhrdpyscqh2jx6u88ssz 1000000uandr --from andr1rnqef6wz6g3dv0dg34jhrdpyscqh2jx64p3xgc --chain-id $CHAIN_ID --fees 5000uandr
```

# Useful Commands
- **Node restart**
```python
sudo systemctl restart andromedad
```
- **Checking logs**
```python
sudo journalctl -u andromedad -f -o cat
```
- **Node Info:**
```python
andromedad status 2>&1 | jq .NodeInfo
```
- **Check Balance:**
```python
andromedad query bank balances andr1rnqef6w..........hrdpyscqh2jx64p3xgc
```






















