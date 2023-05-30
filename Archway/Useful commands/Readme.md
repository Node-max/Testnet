# Key management
### Add new key
```python
archwayd keys add wallet
```
### Recover existing key
```python
archwayd keys add wallet --recover
```
### List all keys
```python
archwayd keys list
```
### Delete key
```python
archwayd keys delete wallet
```
### Export key to the file
```python
archwayd keys export wallet
```
### Import key from the file
```python
archwayd keys import wallet wallet.backup
```
### Query wallet balance
```pythom
archwayd q bank balances $(lavad keys show wallet -a)
```
# Validator management
### Please make sure you have adjusted moniker, identity, details and website to match your values.**
### Create new validator
```python
archwayd tx staking create-validator \
--amount 1000000aconst \
--pubkey $(archwayd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id constantine-3 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 1000000000000aconst \
-y
```
### Edit existing validator
```python
archwayd tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id constantine-3 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 1000000000000aconst \
-y
```
### Unjail validator
```python
archwayd tx slashing unjail --from wallet --chain-id constantine-3 --gas-adjustment 1.4 --gas auto --gas-prices 1000000000000aconst -y
```
### Jail reason
```python
archwayd query slashing signing-info $(archwayd tendermint show-validator)
```
### List all active validators
```python
archwayd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
### List all inactive validators
```python
archwayd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
### View validator details
```python
archwayd q staking validator $(archwayd keys show wallet --bech val -a)
```
# Token management
### Withdraw rewards from all validators
```python
archwayd tx distribution withdraw-all-rewards --from wallet --chain-id constantine-3 --gas-adjustment 1.4 --gas auto --gas-prices 1000000000000aconst -y
```
### Withdraw commission and rewards from your validator
```python
archwayd tx distribution withdraw-rewards $(archwayd keys show wallet --bech val -a) --commission --from wallet --chain-id constantine-3 --gas-adjustment 1.4 --gas auto --gas-prices 1000000000000aconst -y
```
### Delegate tokens to yourself
```python
archwayd tx staking delegate $(archwayd keys show wallet --bech val -a) 1000000aconst --from wallet --chain-id constantine-3 --gas-adjustment 1.4 --gas auto --gas-prices 1000000000000aconst -y
```
### Delegate tokens to validator
```python
archwayd tx staking delegate <TO_VALOPER_ADDRESS> 1000000aconst --from wallet --chain-id constantine-3 --gas-adjustment 1.4 --gas auto --gas-prices 1000000000000aconst -y
```
### Redelegate tokens to another validator
```python
archwayd tx staking redelegate $(archwayd keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000aconst --from wallet --chain-id constantine-3 --gas-adjustment 1.4 --gas auto --gas-prices 1000000000000aconst -y
```
### Unbond tokens from your validator
```python
archwayd tx staking unbond $(archwayd keys show wallet --bech val -a) 1000000aconst --from wallet --chain-id constantine-3 --gas-adjustment 1.4 --gas auto --gas-prices 1000000000000aconst -y
```
### Send tokens to the wallet
```python
archwayd tx bank send wallet <TO_WALLET_ADDRESS> 1000000aconst --from wallet --chain-id constantine-3 --gas-adjustment 1.4 --gas auto --gas-prices 1000000000000aconst -y
```
# Governance
### List all proposals
```python
archwayd query gov proposals
````
### View proposal by id
```python
archwayd query gov proposal 1
```
### Vote 'Yes'
```python
archwayd tx gov vote 1 yes --from wallet --chain-id constantine-3 --gas-adjustment 1.4 --gas auto --gas-prices 1000000000000aconst -y
```
### Vote 'No'
```python
archwayd tx gov vote 1 no --from wallet --chain-id constantine-3 --gas-adjustment 1.4 --gas auto --gas-prices 1000000000000aconst -y
```
### Vote 'Abstain'
```python
archwayd tx gov vote 1 abstain --from wallet --chain-id constantine-3 --gas-adjustment 1.4 --gas auto --gas-prices 1000000000000aconst -y
```
### Vote 'NoWithVeto'
```python
archwayd tx gov vote 1 NoWithVeto --from wallet --chain-id constantine-3 --gas-adjustment 1.4 --gas auto --gas-prices 1000000000000aconst -y
```
# Utility
### Update ports
```python
CUSTOM_PORT=110
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" $HOME/.archway/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}91\"%" $HOME/.archway/config/app.toml
```
## Update Indexer
### Disable indexer
```python
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.archway/config/config.toml
```
### Enable indexer
```python
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.archway/config/config.toml
```
### Update pruning
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.archway/config/app.toml
```
# Maintenance
### Get validator info
```python
archwayd status 2>&1 | jq .ValidatorInfo
```
### Get sync info
```python
archwayd status 2>&1 | jq .SyncInfo
```
### Get node peer
```python
echo $(archwayd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.archway/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### Check if validator key is correct
```python
[[ $(archwayd q staking validator $(archwayd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(archwayd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
### Get live peers
```python
curl -sS http://localhost:15657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
### Set minimum gas price
```python
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0aconst\"/" $HOME/.archway/config/app.toml
```
### Enable prometheus
```python
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.archway/config/config.toml
```
### Reset chain data
```python
archwayd tendermint unsafe-reset-all --home $HOME/.archway --keep-addr-book
```
## Remove node
### Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your priv_validator_key.json!
```python
cd $HOME
sudo systemctl stop archwayd
sudo systemctl disable archwayd
sudo rm /etc/systemd/system/archwayd.service
sudo systemctl daemon-reload
rm -f $(which archwayd)
rm -rf $HOME/.archway
rm -rf $HOME/archway
```
## Service Management
### Reload service configuration
```python
sudo systemctl daemon-reload
```
### Enable service
```python
sudo systemctl enable archwayd
```
### Disable service
```python
sudo systemctl disable archwayd
```
### Start service
```python
sudo systemctl start archwayd
```
### Stop service
```python
sudo systemctl stop archwayd
```
### Restart service
```python
sudo systemctl restart archwayd
```
### Check service status
```python
sudo systemctl status archwayd
```
### Check service logs
```python
sudo journalctl -u archwayd -f --no-hostname -o cat
```
