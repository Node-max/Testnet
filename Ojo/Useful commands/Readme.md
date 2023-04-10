# Working with a wallet
- **Add new key**
```python
ojod keys add wallet
```
- **Recover existing key**
```python
ojod keys add wallet --recover
```
- **List all keys**
```python
ojod keys list
```
- **Delete key**
```python
ojod keys delete wallet
```
- **Export key to the file**
```python
ojod keys export wallet
```
- **Import key from the file**
```python
ojod keys import wallet wallet.backup
```
- **Query wallet balance**
```python
ojod q bank balances $(defundd keys show wallet -a)
```
## Please make sure you have adjusted moniker, identity, details and website to match your values.

# Working with the validator
- **Create new validator**
```python
ojod tx staking create-validator \
--amount 1000000uojo \
--pubkey $(ojod tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id ojo-devnet \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0uojo \
-y
```
- **Edit existing validator**
```python
ojod tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id ojo-devnet \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0uojo \
-y
```
- **Unjail validator**
```python
ojod tx slashing unjail --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
- **Jail reason**
```python
ojod query slashing signing-info $(ojod tendermint show-validator)
```
- **List all active validators**
```python
ojod q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **List all inactive validators**
```python
ojod q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **View validator details**
```python
ojod q staking validator $(ojod keys show wallet --bech val -a)
```
# Transactions
- **Withdraw rewards from all validators**
```python
ojod tx distribution withdraw-all-rewards --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
- **Withdraw commission and rewards from your validator**
```python
ojod tx distribution withdraw-rewards $(ojod keys show wallet --bech val -a) --commission --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
- **Delegate tokens to yourself**
```python
ojod tx staking delegate $(ojod keys show wallet --bech val -a) 1000000uojo --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
- **Delegate tokens to validator**
```python
ojod tx staking delegate <TO_VALOPER_ADDRESS> 1000000uojo --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
- **Redelegate tokens to another validator**
```python
ojod tx staking redelegate $(ojod keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000uojo --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
- **Unbond tokens from your validator**
```python
ojod tx staking unbond $(ojod keys show wallet --bech val -a) 1000000uojo --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
- **Send tokens to the wallet**
```python
ojod tx bank send wallet <TO_WALLET_ADDRESS> 1000000uojo --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
# Governance
- **List all proposals**
```pytho
ojod query gov proposals
```
- **View proposal by id**
```python
ojod query gov proposal 1
```
- **Vote 'Yes'**
```python
ojod tx gov vote 1 yes --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
- **Vote 'No'**
```python
ojod tx gov vote 1 no --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
- **Vote 'Abstain'**
```python
ojod tx gov vote 1 abstain --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
- **Vote 'NoWithVeto'**
```python
ojod tx gov vote 1 NoWithVeto --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
# Additional utilities
- **Update ports**
```python
CUSTOM_PORT=10
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.ojo/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.ojo/config/app.toml
```
**Update Indexer**
- **Disable indexer**
```python
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.ojo/config/config.toml
```
- **Enable indexer**
```python
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.ojo/config/config.toml
```
- **Update pruning**
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.ojo/config/app.toml
  ```
# Maintenance
- **Get validator info**
```python
ojod status 2>&1 | jq .ValidatorInfo
```
- **Get sync info**
```python
ojod status 2>&1 | jq .SyncInfo
```
- **Get node peer**
```python
echo $(ojod tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.ojo/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
- **Check if validator key is correct**
```python
[[ $(ojod q staking validator $(ojod keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(ojod status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
- **Get live peers**
```python
curl -sS http://localhost:50657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
- **Set minimum gas price**
```python
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uojo\"/" $HOME/.ojo/config/app.toml
```
- **Enable prometheus**
```python
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.ojo/config/config.toml
```
- **Reset chain data**
```python
ojod tendermint unsafe-reset-all --home $HOME/.ojo --keep-addr-book
```
- **Remove node**
**Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your 
priv_validator_key.json!**
```python
cd $HOME
sudo systemctl stop ojod
sudo systemctl disable ojod
sudo rm /etc/systemd/system/ojod.service
sudo systemctl daemon-reload
rm -f $(which ojod)
rm -rf $HOME/.ojo
rm -rf $HOME/ojo
```
# Service Management
- **Reload service configuration**
```python
sudo systemctl daemon-reload
```
- **Enable service**
```python
sudo systemctl enable ojod
```
- **Disable service**
```python
sudo systemctl disable ojod
```
- **Start service**
```python
sudo systemctl start ojod
```
- **Stop service**
```python
sudo systemctl stop ojod
```
- **Restart service**
```python
sudo systemctl restart ojod
```
- **Check service status**
```python
sudo systemctl status ojod
```
- **Check service status**
```python
sudo systemctl status ojod
```
- **Check service logs**
```python
sudo journalctl -u ojod -f --no-hostname -o cat
```
