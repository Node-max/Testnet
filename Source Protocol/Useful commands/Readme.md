# Working with a wallet
- **Add new key**
```python
sourced keys add wallet
```
- **Recover existing key**
```python
sourced keys add wallet --recover
```
- **List all keys**
```python
sourced keys list
```
- **Delete key**
```python
sourced keys delete wallet
```
- **Export key to the file**
```python
sourced keys export wallet
```
- **Import key from the file**
```python
sourced keys import wallet wallet.backup
```
- **Query wallet balance**
```python
sourced q bank balances $(sourced keys show wallet -a)
```
# Working with the validator
- **Create new validator**
```python
sourced tx staking create-validator \
--amount 1000000usource \
--pubkey $(sourced tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id sourcechain-testnet \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0usource \
-y
```
- **Edit existing validator**
```python
sourced tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id sourcechain-testnet \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0usource \
-y
```
- **Unjail validator**
```python
sourced tx slashing unjail --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 0usource -y
```
- **Jail reason**
```python
sourced query slashing signing-info $(sourced tendermint show-validator)
```
- **List all active validators**
```python
sourced q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **List all inactive validators**
```python
sourced q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **View validator details**
```python
sourced q staking validator $(sourced keys show wallet --bech val -a)
```
# Transactions
- **Withdraw rewards from all validators**
```python
sourced tx distribution withdraw-all-rewards --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 0usource -y
```
- **Withdraw commission and rewards from your validator**
```python
sourced tx distribution withdraw-rewards $(sourced keys show wallet --bech val -a) --commission --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 0usource -y
```
- **Delegate tokens to yourself**
```python
sourced tx staking delegate $(sourced keys show wallet --bech val -a) 1000000usource --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 0usource -y
```
- **Delegate tokens to validator**
```python
sourced tx staking delegate <TO_VALOPER_ADDRESS> 1000000usource --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 0usource -y
```
- **Redelegate tokens to another validator**
```python
sourced tx staking redelegate $(sourced keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000usource --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 0usource -y
```
- **Unbond tokens from your validator**
```python
sourced tx staking unbond $(sourced keys show wallet --bech val -a) 1000000usource --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 0usource -y
```
- **Send tokens to the wallet**
```python
sourced tx bank send wallet <TO_WALLET_ADDRESS> 1000000usource --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 0usource -y
```
# Governance
- **List all proposals**
```pytho
sourced query gov proposals
```
- **View proposal by id**
```python
sourced query gov proposal 1
```
- **Vote 'Yes'**
```python
sourced tx gov vote 1 yes --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 0usource -y
```
- **Vote 'No'**
```python
sourced tx gov vote 1 no --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 0usource -y
```
- **Vote 'Abstain'**
```python
sourced tx gov vote 1 abstain --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 
0usource -y
```
- **Vote 'NoWithVeto'**
```python
sourced tx gov vote 1 NoWithVeto --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 0usource -y
```
# Additional utilities
- **Update ports**
```python
CUSTOM_PORT=10
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.source/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.source/config/app.toml
```
**Update Indexer**
- **Disable indexer**
```python
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.source/config/config.toml
```
- **Enable indexer**
```python
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.source/config/config.toml
```
- **Update pruning**
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.source/config/app.toml
  ```
# Maintenance
- **Get validator info**
```python
sourced status 2>&1 | jq .ValidatorInfo
```
- **Get sync info**
```python
sourced status 2>&1 | jq .SyncInfo
```
- **Get node peer**
```python
echo $(sourced tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.source/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
- **Check if validator key is correct**
```python
[[ $(sourced q staking validator $(sourced keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(sourced status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
- **Get live peers**
```python
curl -sS http://localhost:28657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
- **Set minimum gas price**
```python
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0usource\"/" $HOME/.source/config/app.toml
```
- **Enable prometheus**
```python
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.source/config/config.toml
```
- **Reset chain data**
```python
sourced tendermint unsafe-reset-all --home $HOME/.source --keep-addr-book
```
- **Remove node**
**Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your 
priv_validator_key.json!**
```python
cd $HOME
sudo systemctl stop sourced
sudo systemctl disable sourced
sudo rm /etc/systemd/system/sourced.service
sudo systemctl daemon-reload
rm -f $(which sourced)
rm -rf $HOME/.source
rm -rf $HOME/source
```
# Service Management
- **Reload service configuration**
```python
sudo systemctl daemon-reload
```
- **Enable service**
```python
sudo systemctl enable sourced
```
- **Disable service**
```python
sudo systemctl disable sourced
```
- **Start service**
```python
sudo systemctl start sourced
```
- **Stop service**
```python
sudo systemctl stop sourced
```
- **Restart service**
```python
sudo systemctl restart sourced
```
- **Check service status**
```python
sudo systemctl status sourced
```
- **Check service logs**
```python
sudo journalctl -u sourced -f --no-hostname -o cat
```


