**save the seed phrase**
```python
nolusd keys add <YOUR_WALLET_NAME>
```
- **Recover wallet**
save the **seed** phrase
```python
nolusd keys add <YOUR_WALLET_NAME> --recover
```
- **List of all wallets**
```python
nolusd keys list
```
- **Remove wallet**
```python
nolusd keys delete <YOUR_WALLET_NAME>
```
- **Export wallet**
**save to wallet.backup**
```python
nolusd keys export <YOUR_WALLET_NAME>
```
- **Import a wallet**
```python
nolusd keys import <WALLET_NAME> wallet.backup
```
- **Check the wallet balance**
```python
nolusd q bank balances $(nibid keys show wallet -a)
```
# Working with the validator
```python
nolusd tx staking create-validator \
--amount 1000000unls \
--pubkey $(nolusd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id nolus-rila \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--fees 2500unls \
-y
```
- **Edit your validator**
```python
nolusd tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id nolus-rila \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--fees 2500unls \
-y
```
- **Get the validator out of jail**
```python
nolusd tx slashing unjail --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 2500unls -y
```
- **See information on blocks**
```python
nolusd query slashing signing-info $(nolusd tendermint show-validator)
```
- **List of active validators**
```python
nolusd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **List of inactive validators**
```python
nolusd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **View information about your validator**
```python
nolusd q staking validator $(nolusd keys show wallet --bech val -a)
```
# Transactions
- **Collect rewards from all validators**
```python
nolusd tx distribution withdraw-all-rewards --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 2500unls -y
```
- **Collect rewards and commission from your validator**
```python
nolusd tx distribution withdraw-rewards $(nolusd keys show wallet --bech val -a) --commission --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 2500unls -y
```
- **Delegate to your validator**
```python
nolusd tx staking delegate $(nolusd keys show wallet --bech val -a) 1000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 2500unls -y
```
- **Delegate tokens to the validator**
```python
nolusd tx staking delegate <TO_VALOPER_ADDRESS> 1000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 2500unls -y
```
- **Redelegate tokens to another validator**
```python
nolusd tx staking redelegate $(nolusd keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 2500unls -y
```
- **Collect tokens from the validator**
there may be a long waiting time for the tokens to arrive in the wallet
```python
nolusd tx staking unbond $(nolusd keys show wallet --bech val -a) 1000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 2500unls -y
```
- **Send tokens to another wallet**
```python
nolusd tx bank send wallet <TO_WALLET_ADDRESS> 1000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 2500unls -y
```
- **Verification of information on TX_HASH**
```python
nolusd query tx <TX_HASH>
```
# Governance
- **List of all offers**
```python
nolusd query gov proposals
```
- **View the proposal by <proposal_id>**
```python
nolusd query gov proposal <proposal_id>
```
- **Vote as, YES**
```python
nolusd tx gov vote 1 yes --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 2500unls -y
```
- **Vote as, NO**
```python
nolusd tx gov vote 1 no --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 2500unls -y
```
- **Vote as, NO_WITH_VETO**
```python
nolusd tx gov vote 1 NoWithVeto --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 2500unls -y
```
- **Vote as, ABSTAIN**
```python
nolusd tx gov vote 1 abstain --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 2500unls -y
```
# Additional utilities
- **Changing ports to custom**
```python
CUSTOM_PORT=14
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.nolus/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.nolus/config/app.toml
```
- **Enable indexing**
```python
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.nolus/config/config.toml
```
- **Remove indexing**
```python
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.nolus/config/config.toml
```
- **Configure prunning**
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.nolus/config/app.toml
  ```
- **Look at your peer**
```python
echo $(nolusd tendermint show-node-id)@$(curl ifconfig.me)$(grep -A 3 "\[p2p\]" ~/.nolus/config/config.toml | egrep -o ":[0-9]+")
```
- **View your RPC**
```python
echo -e "\033[0;32m$(grep -A 3 "\[rpc\]" ~/.nolus/config/config.toml | egrep -o ":[0-9]+")\033[0m"
```
- **View information about the validator**
```python
nolusd status 2>&1 | jq .ValidatorInfo
```
- **See the node synchronization status (false - synced, true - not synced)**
```python
nolusd status 2>&1 | jq .SyncInfo.catching_up
```
- **Check the last block**
```python
nolusd status 2>&1 | jq .SyncInfo.latest_block_height
```
- **Reset network**
```python
nolusd tendermint unsafe-reset-all --home $HOME/.nolus --keep-addr-book
```
- **Delete a node**
```python
cd $HOME
sudo systemctl stop nolusd
sudo systemctl disable nolusd
sudo rm /etc/systemd/system/nolusd.service
sudo systemctl daemon-reload
rm -f $(which nolusd)
rm -rf $HOME/.nolus
rm -rf $HOME/nolus-core
```
- **Get the IP address of the server**
```python
wget -qO- eth0.me
```
- **Network settings**
```python
nolusd q staking params
nolusd q slashing params
```
- **Search all outgoing transactions by address**
```python
nolusd q txs --events transfer.sender=<ADDRESS> 2>&1 | jq | grep txhash
```
- **Search all incoming transactions by address**
```python
nolusd q txs --events transfer.recipient=<ADDRESS> 2>&1 | jq | grep txhash
```
# Service management
- **Restart services**
```python
sudo systemctl daemon-reload
```
- **Turn on the service**
```python
sudo systemctl enable nolusd
```
- **Turn off the service**
```python
sudo systemctl disable nolusd
```
- **Start the service**
```python
sudo systemctl start nolusd
```
- **Stop the service**
```python
sudo systemctl stop nolusd
```
- **Restart the service**
```python
sudo systemctl restart nolusd
```
- **Check the service status**
```python
sudo systemctl status nolusd
```
- **Check the service logs**
```python
sudo journalctl -u nolusd -f --no-hostname -o cat
```
