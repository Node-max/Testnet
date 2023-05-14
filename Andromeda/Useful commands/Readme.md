# Working with a wallet
- **Add new key**
```python
andromedad keys add wallet
```
- **Recover existing key**
```python
andromedad keys add wallet --recover
```
- **List all keys**
```python
andromedad keys list
```
- **Delete key**
```python
andromedad keys delete wallet
```
- **Export key to the file**
```python
andromedad keys export wallet
```
- **Import key from the file**
```python
andromedad keys import wallet wallet.backup
```
- **Query wallet balance**
```python
andromedad q bank balances $(andromedad keys show wallet -a)
```
## Please make sure you have adjusted moniker, identity, details and website to match your values.

# Working with the validator
- **Create new validator**
```python
andromedad tx staking create-validator \
--amount 1000000uandr \
--pubkey $(andromedad tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id galileo-3 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001uandr \
-y
```
- **Edit existing validator**
```python
andromedad tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id galileo-3 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001uandr \
-y
```
- **Unjail validator**
```python
andromedad tx slashing unjail --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
- **Jail reason**
```python
andromedad query slashing signing-info $(andromedad tendermint show-validator)
```
- **List all active validators**
```python
andromedad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **List all inactive validators**
```python
andromedad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **View validator details**
```python
andromedad q staking validator $(andromedad keys show wallet --bech val -a)
```
# Transactions
- **Withdraw rewards from all validators**
```python
andromedad tx distribution withdraw-all-rewards --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
- **Withdraw commission and rewards from your validator**
```python
andromedad tx distribution withdraw-rewards $(andromedad keys show wallet --bech val -a) --commission --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
- **Delegate tokens to yourself**
```python
andromedad tx staking delegate $(andromedad keys show wallet --bech val -a) 1000000uandr --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
- **Delegate tokens to validator**
```python
andromedad tx staking delegate <TO_VALOPER_ADDRESS> 1000000uandr --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
- **Redelegate tokens to another validator**
```python
andromedad tx staking redelegate $(andromedad keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000uandr --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
- **Unbond tokens from your validator**
```python
andromedad tx staking unbond $(andromedad keys show wallet --bech val -a) 1000000uandr --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
- **Send tokens to the wallet**
```python
andromedad tx bank send wallet <TO_WALLET_ADDRESS> 1000000uandr --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
# Governance
- **List all proposals**
```pytho
andromedad query gov proposals
```
- **View proposal by id**
```python
andromedad query gov proposal 1
```
- **Vote 'Yes'**
```python
andromedad tx gov vote 1 yes --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
- **Vote 'No'**
```python
andromedad tx gov vote 1 no --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
- **Vote 'Abstain'**
```python
andromedad tx gov vote 1 abstain --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
- **Vote 'NoWithVeto'**
```python
andromedad tx gov vote 1 NoWithVeto --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
# Additional utilities
- **Update ports**
```python
CUSTOM_PORT=10
CUSTOM_PORT=10
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.andromedad/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.andromedad/config/app.toml
```
**Update Indexer**
- **Disable indexer**
```python
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.andromedad/config/config.toml
```
- **Enable indexer**
```python
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.andromedad/config/config.toml
```
- **Update pruning**
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.andromedad/config/app.toml
  ```
# Maintenance
- **Get validator info**
```python
andromedad status 2>&1 | jq .ValidatorInfo
```
- **Get sync info**
```python
andromedad status 2>&1 | jq .SyncInfo
```
- **Get node peer**
```python
echo $(andromedad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.andromedad/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
- **Check if validator key is correct**
```python
[[ $(andromedad q staking validator $(andromedad keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(andromedad status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
- **Get live peers**
```python
curl -sS http://localhost:47657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
- **Set minimum gas price**
```python
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0001uandr\"/" $HOME/.andromedad/config/app.toml
```
- **Enable prometheus**
```python
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.andromedad/config/config.toml
```
- **Reset chain data**
```python
andromedad tendermint unsafe-reset-all --home $HOME/.andromedad --keep-addr-book
```
- **Remove node**
**Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your 
priv_validator_key.json!**
```python
cd $HOME
sudo systemctl stop andromedad
sudo systemctl disable andromedad
sudo rm /etc/systemd/system/andromedad.service
sudo systemctl daemon-reload
rm -f $(which andromedad)
rm -rf $HOME/.andromedad
rm -rf $HOME/andromedad
```
# Service Management
- **Reload service configuration**
```python
sudo systemctl daemon-reload
```
- **Enable service**
```python
sudo systemctl enable andromedad
```
- **Disable service**
```python
sudo systemctl disable andromedad
```
- **Start service**
```python
sudo systemctl start andromedad
```
- **Stop service**
```python
sudo systemctl stop andromedad
```
- **Restart service**
```python
sudo systemctl restart andromedad
```
- **Check service status**
```python
sudo systemctl status andromedad
```
- **Check service status**
```python
sudo systemctl status andromedad
```
- **Check service logs**
```python
sudo journalctl -u andromedad -f --no-hostname -o cat
```
