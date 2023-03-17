# Auto installation

wget -O sources https://raw.githubusercontent.com/Node-max/Testnet/main/Quasar/Node_installation_guide/auto_qussar && chmod +x sources && ./sources

# Manual installation

### Preparing the server
```python
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

## GO 1.19
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

# Build 12.02.23
```python
cd $HOME
wget https://github.com/quasar-finance/binary-release/raw/main/v0.0.2-alpha-11/quasarnoded-linux-amd64
chmod +x quasarnoded-linux-amd64
mkdir go && mkdir go/bin
mv quasarnoded-linux-amd64 $HOME/go/bin/quasarnoded
```

*******🟢UPDATE🟢******* 00.00.23
```python
SOOON
```

`quasarnoded version --long`
- commit: c426178652265b29f7c3ea05b6e144542584e523
- version: 0.0.2-alpha-11

```python
quasarnoded init <your moniker name> --chain-id qsr-questnet-04
quasarnoded config chain-id qsr-questnet-04
```    

## Create/recover wallet
```python
quasarnoded keys add <walletname>
  OR
quasarnoded keys add <walletname> --recover
```

## Download Genesis
```python
wget -O $HOME/.quasarnode/config/genesis.json "https://raw.githubusercontent.com/Node-max/Testnet/main/Quasar/Node_installation_guide/genesis.json"
```
`sha256sum $HOME/.quasarnode/config/genesis.json`
+ 8f38e35f88f4cbe983f7791d0d49b3f4123660c472408892c46ab145855fe3a5

## Set up the minimum gas price and Peers/Seeds/Filter peers/MaxPeers
```python
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0uqsr\"/;" ~/.quasarnode/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.quasarnode/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.quasarnode/config/config.toml
peers="c6a18679340e7011206d1e3e05ece1aac7a4e731@5.182.33.99:32656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.quasarnode/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.quasarnode/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.quasarnode/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.quasarnode/config/config.toml

```
### Pruning (optional)
```python
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.quasarnode/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.quasarnode/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.quasarnode/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.quasarnode/config/app.toml
```
### Indexer (optional) 
```bash
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.quasarnode/config/config.toml
```

## Download addrbook
```python
wget -O $HOME/.quasarnode/config/addrbook.json "https://raw.githubusercontent.com/Node-max/Testnet/main/Quasar/Node_installation_guide/addrbook.json"
```

# Create a service file
```python
sudo tee /etc/systemd/system/quasarnoded.service > /dev/null <<EOF
[Unit]
Description=quasarnoded
After=network-online.target

[Service]
User=$USER
ExecStart=$(which quasarnoded) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Start
```python
sudo systemctl daemon-reload
sudo systemctl enable quasarnoded
sudo systemctl restart quasarnoded && sudo journalctl -u quasarnoded -f -o cat
```

### Create validator
```python
quasarnoded tx staking create-validator \
  --amount=1000000uqsr \
  --pubkey=$(quasarnoded tendermint show-validator) \
  --moniker="your name" \
  --details="" \
  --identity="" \
  --website="" \
  --chain-id="qsr-questnet-04" \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --from=WalletName -y
```

## Delete node
```python
sudo systemctl stop quasarnoded && \
sudo systemctl disable quasarnoded && \
rm /etc/systemd/system/quasarnoded.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .quasarnode && \
rm -rf $(which quasarnoded)
```
#
### Sync Info
```python
quasarnoded status 2>&1 | jq .SyncInfo
```
### NodeINfo
```python
quasarnoded status 2>&1 | jq .NodeInfo
```
### Check node logs
```python
sudo journalctl -u quasarnoded -f -o cat
```
### Check Balance
```python
quasarnoded query bank balances quasar1ksau2q..........p45gkecvdpgc5y8pxrmpc
```

