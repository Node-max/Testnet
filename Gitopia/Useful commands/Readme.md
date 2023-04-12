# Working with a wallet
- **Add new key**
```python
gitopiad keys add wallet
```
- **Recover existing key**
```python
gitopiad keys add wallet --recover
```
- **List all keys**
```python
gitopiad keys list
```
- **Delete key**
```python
gitopiad keys delete wallet
```
- **Export key to the file**
```python
gitopiad keys export wallet
```
- **Import key from the file**
```python
gitopiad keys import wallet wallet.backup
```
- **Query wallet balance**
```python
gitopiad q bank balances $(gitopiad keys show wallet -a)
```
## Please make sure you have adjusted moniker, identity, details and website to match your values.

# Working with the validator
- **Create new validator**
```python
gitopiad tx staking create-validator \
--amount 1000000utlore \
--pubkey $(gitopiad tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id gitopia-janus-testnet-2 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.001utlore \
-y
```
- **Edit existing validator**
```python
gitopiad tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id gitopia-janus-testnet-2 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.001utlore \
-y
```
- **Unjail validator**
```python
gitopiad tx slashing unjail --from wallet --chain-id gitopia-janus-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.001utlore -y
```
- **Jail reason**
```python
gitopiad query slashing signing-info $(gitopiad tendermint show-validator)
```
- **List all active validators**
```python
gitopiad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **List all inactive validators**
```python
gitopiad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **View validator details**
```python
gitopiad q staking validator $(gitopiad keys show wallet --bech val -a)
```
# Transactions
- **Withdraw rewards from all validators**
```python
gitopiad tx distribution withdraw-all-rewards --from wallet --chain-id gitopia-janus-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.001utlore -y
```
- **Withdraw commission and rewards from your validator**
```python
gitopiad tx distribution withdraw-rewards $(gitopiad keys show wallet --bech val -a) --commission --from wallet --chain-id gitopia-janus-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.001utlore -y
```
- **Delegate tokens to yourself**
```python
gitopiad tx staking delegate $(gitopiad keys show wallet --bech val -a) 1000000utlore --from wallet --chain-id gitopia-janus-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.001utlore -y
```
- **Delegate tokens to validator**
```python
gitopiad tx staking delegate <TO_VALOPER_ADDRESS> 1000000utlore --from wallet --chain-id gitopia-janus-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.001utlore -y
```
- **Redelegate tokens to another validator**
```python
gitopiad tx staking redelegate $(gitopiad keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000utlore --from wallet --chain-id gitopia-janus-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.001utlore -y
```
- **Unbond tokens from your validator**
```python
gitopiad tx staking unbond $(gitopiad keys show wallet --bech val -a) 1000000utlore --from wallet --chain-id gitopia-janus-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.001utlore -y
```
- **Send tokens to the wallet**
```python
gitopiad tx bank send wallet <TO_WALLET_ADDRESS> 1000000utlore --from wallet --chain-id gitopia-janus-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.001utlore -y
```
# Governance
- **List all proposals**
```pytho
gitopiad query gov proposals
```
- **View proposal by id**
```python
gitopiad query gov proposal 1
```
- **Vote 'Yes'**
```python
gitopiad tx gov vote 1 yes --from wallet --chain-id gitopia-janus-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.001utlore -y
```
- **Vote 'No'**
```python
gitopiad tx gov vote 1 no --from wallet --chain-id gitopia-janus-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.001utlore -y
```
- **Vote 'Abstain'**
```python
gitopiad tx gov vote 1 abstain --from wallet --chain-id gitopia-janus-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.001utlore -y
```
- **Vote 'NoWithVeto'**
```python
gitopiad tx gov vote 1 NoWithVeto --from wallet --chain-id gitopia-janus-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.001utlore -y
```
# Additional utilities
- **Update ports**
```python
CUSTOM_PORT=10
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.gitopia/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.gitopia/config/app.toml
```
**Update Indexer**
- **Disable indexer**
```python
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.gitopia/config/config.toml
```
- **Enable indexer**
```python
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.gitopia/config/config.toml
```
- **Update pruning**
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.gitopia/config/app.toml
  ```
# Maintenance
- **Get validator info**
```python
gitopiad status 2>&1 | jq .ValidatorInfo
```
- **Get sync info**
```python
gitopiad status 2>&1 | jq .SyncInfo
```
- **Get node peer**
```python
echo $(gitopiad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.gitopia/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
- **Check if validator key is correct**
```python
[[ $(gitopiad q staking validator $(gitopiad keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(gitopiad status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
- **Get live peers**
```python
curl -sS http://localhost:41657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
- **Set minimum gas price**
```python
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001utlore\"/" $HOME/.gitopia/config/app.toml
```
- **Enable prometheus**
```python
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.gitopia/config/config.toml
```
- **Reset chain data**
```python
gitopiad tendermint unsafe-reset-all --home $HOME/.gitopia --keep-addr-book
```
- **Remove node**
**Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your 
priv_validator_key.json!**
```python
cd $HOME
sudo systemctl stop gitopiad
sudo systemctl disable gitopiad
sudo rm /etc/systemd/system/gitopiad.service
sudo systemctl daemon-reload
rm -f $(which gitopiad)
rm -rf $HOME/.gitopia
rm -rf $HOME/gitopia
```
# Service Management
- **Reload service configuration**
```python
sudo systemctl daemon-reload
```
- **Enable service**
```python
sudo systemctl enable gitopiad
```
- **Disable service**
```python
sudo systemctl disable gitopiad
```
- **Start service**
```python
sudo systemctl start gitopiad
```
- **Stop service**
```python
sudo systemctl stop gitopiad
```
- **Restart service**
```python
sudo systemctl restart gitopiad
```
- **Check service status**
```python
sudo systemctl status gitopiad
```
- **Check service logs**
```python
sudo journalctl -u gitopiad -f --no-hostname -o cat
```

