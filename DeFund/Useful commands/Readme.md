# Working with a wallet
- **Add new key**
```python
defundd keys add wallet
```
- **Recover existing key**
```python
defundd keys add wallet --recover
```
- **List all keys**
```python
defundd keys list
```
- **Delete key**
```python
defundd keys delete wallet
```
- **Export key to the file**
```python
defundd keys export wallet
```
- **Import key from the file**
```python
defundd keys import wallet wallet.backup
```
- **Query wallet balance**
```python
defundd q bank balances $(defundd keys show wallet -a)
```
## Please make sure you have adjusted moniker, identity, details and website to match your values.

# Working with the validator
- **Create new validator**
```python
defundd tx staking create-validator \
--amount 1000000ufetf \
--pubkey $(defundd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id orbit-alpha-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0ufetf \
-y
```
- **Edit existing validator**
```python
defundd tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id orbit-alpha-1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0ufetf \
-y
```
- **Unjail validator**
```python
defundd tx slashing unjail --from wallet --chain-id orbit-alpha-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ufetf -y
```
- **Jail reason**
```python
defundd query slashing signing-info $(defundd tendermint show-validator)
```
- **List all active validators**
```python
defundd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **List all inactive validators**
```python
defundd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **View validator details**
```python
defundd q staking validator $(defundd keys show wallet --bech val -a)
```
# Transactions
- **Withdraw rewards from all validators**
```python
defundd tx distribution withdraw-all-rewards --from wallet --chain-id orbit-alpha-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ufetf -y
```
- **Withdraw commission and rewards from your validator**
```python
defundd tx distribution withdraw-rewards $(defundd keys show wallet --bech val -a) --commission --from wallet --chain-id orbit-alpha-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ufetf -y
```
- **Delegate tokens to yourself**
```python
defundd tx staking delegate $(defundd keys show wallet --bech val -a) 1000000ufetf --from wallet --chain-id orbit-alpha-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ufetf -y
```
- **Delegate tokens to validator**
```python
defundd tx staking delegate <TO_VALOPER_ADDRESS> 1000000ufetf --from wallet --chain-id orbit-alpha-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ufetf -y
```
- **Redelegate tokens to another validator**
```python
defundd tx staking redelegate $(defundd keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000ufetf --from wallet --chain-id orbit-alpha-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ufetf -y
```
- **Unbond tokens from your validator**
```python
defundd tx staking unbond $(defundd keys show wallet --bech val -a) 1000000ufetf --from wallet --chain-id orbit-alpha-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ufetf -y
```
- **Send tokens to the wallet**
```python
defundd tx bank send wallet <TO_WALLET_ADDRESS> 1000000ufetf --from wallet --chain-id orbit-alpha-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ufetf -y
```
# Governance
- **List all proposals**
```pytho
defundd query gov proposals
```
- **View proposal by id**
```python
defundd query gov proposal 1
```
- **Vote 'Yes'**
```python
defundd tx gov vote 1 yes --from wallet --chain-id orbit-alpha-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ufetf -y
```
- **Vote 'No'**
```python
defundd tx gov vote 1 no --from wallet --chain-id orbit-alpha-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ufetf -y
```
- **Vote 'Abstain'**
```python
defundd tx gov vote 1 abstain --from wallet --chain-id orbit-alpha-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ufetf -y
```
- **Vote 'NoWithVeto'**
```python
defundd tx gov vote 1 NoWithVeto --from wallet --chain-id orbit-alpha-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ufetf -y
```
# Additional utilities
- **Update ports**
```python
CUSTOM_PORT=10
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.defund/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.defund/config/app.toml
```
**Update Indexer**
- **Disable indexer**
```python
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.defund/config/config.toml
```
- **Enable indexer**
```python
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.defund/config/config.toml
```
- **Update pruning**
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.defund/config/app.toml
  ```
# Maintenance
- **Get validator info**
```python
defundd status 2>&1 | jq .ValidatorInfo
```
- **Get sync info**
```python
defundd status 2>&1 | jq .SyncInfo
```
- **Get node peer**
```python
echo $(defundd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.defund/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
- **Check if validator key is correct**
```python
[[ $(defundd q staking validator $(defundd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(defundd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
- **Get live peers**
```python
curl -sS http://localhost:40657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
- **Set minimum gas price**
```python
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ufetf\"/" $HOME/.defund/config/app.toml
```
- **Enable prometheus**
```python
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.defund/config/config.toml
```
- **Reset chain data**
```python
defundd tendermint unsafe-reset-all --home $HOME/.defund --keep-addr-book
```
- **Remove node**
**Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your 
priv_validator_key.json!**
```python
cd $HOME
sudo systemctl stop defundd
sudo systemctl disable defundd
sudo rm /etc/systemd/system/defundd.service
sudo systemctl daemon-reload
rm -f $(which defundd)
rm -rf $HOME/.defund
rm -rf $HOME/defund
```
# Service Management
- **Reload service configuration**
```python
sudo systemctl daemon-reload
```
- **Enable service**
```python
sudo systemctl enable defundd
```
- **Disable service**
```python
sudo systemctl disable defundd
```
- **Start service**
```python
sudo systemctl start defundd
```
- **Stop service**
```python
sudo systemctl stop defundd
```
- **Restart service**
```python
sudo systemctl restart defundd
```
- **Check service status**
```python
sudo systemctl status defundd
```
- **Check service status**
```python
sudo systemctl status defundd
```
- **Check service logs**
```python
sudo journalctl -u defundd -f --no-hostname -o cat
```
