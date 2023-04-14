# Working with a wallet
- **Add new key**
```python
babylond keys add <YOUR_WALLET_NAME>
```
- **Recover existing key**
```python
babylond keys add <YOUR_WALLET_NAME> --recover
```
- **List all keys**
```python
babylond keys list
```
- **Delete key**
```python
babylond keys delete <YOUR_WALLET_NAME>
```
- **Export key to the file**
```python
babylond keys export <YOUR_WALLET_NAME>
```
- **Import key from the file**
```python
babylond keys import <WALLET_NAME> wallet.backup
```
- **Query wallet balance**
```python
babylond q bank balances $(babylond keys show <WALLET_NAME> -a)
```
## Please make sure you have adjusted moniker, identity, details and website to match your values.

# Working with the validator
- **Create new validator**
```python
babylond tx checkpointing create-validator \
--amount=50ubbn \
--pubkey=$(babylond tendermint show-validator) \
--moniker="<Your moniker>" \
--identity=<Your identity> \
--details="<Your details>" \
--chain-id=bbn-test1 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=<YOUR_WALLET> \
--fees=20ubbn
-y
```
- **Edit existing validator**
```python
babylond tx staking edit-validator \
--new-moniker="<Your moniker>" \
--identity=<your identity> \
--details="<Your details>" \
--commission-rate=0.1 \
--from=<YOUR_WALLET> \
--gas-prices=0.1ubbn \
--gas-adjustment=1.5 \
--gas=auto \
-y
```
- **Unjail validator**
```python
babylond tx slashing unjail --from <YOUR_WALLET> --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto -y
```
- **Jail reason**
```python
babylond query slashing signing-info $(babylond tendermint show-validator)
```
- **List all active validators**
```python
babylond q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **List all inactive validators**
```python
babylond q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED") or .status=="BOND_STATUS_UNBONDING")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **View validator details**
```python
babylond q staking validator $(babylond keys show <WALLET_NAME> --bech val -a)
```
# Transactions
- **Withdraw rewards from all validators**
```python
babylond tx distribution withdraw-all-rewards --from <YOUR_WALLET> --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto -y
```
- **Withdraw commission and rewards from your validator**
```python
babylond tx distribution withdraw-rewards $(babylond keys show <YOUR_WALLET> --bech val -a) --commission --from <YOUR_WALLET> --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto -y
```
- **Delegate tokens to yourself**
```python
babylond tx staking delegate $(babylond keys show <YOUR_WALLET> --bech val -a) 1000000ubbn --from <YOUR_WALLET> --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto -y
```
- **Delegate tokens to validator**
```python
babylond tx staking delegate <VALOPER_ADDRESS> 1000000ubbn --from <YOUR_WALLET> --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto -y
```
- **Redelegate tokens to another validator**
```python
babylond tx staking redelegate <SRC_VALOPER_ADDRESS> <TARGET_VALOPER_ADDRESS> 1000000ubbn --from <WALLET> --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto -y
```
- **Unbond tokens from your validator**
```python
babylond tx staking unbond <VALOPER_ADDRESS> 1000000ubbn --from <YOUR_WALLET> --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto -y
```
- **Send tokens to the wallet**
```python
babylond tx bank send <YOUR_WALLET_ADDRESS> <TARGET_WALLET_ADDRESS> 1000000ubbn --from <YOUR_WALLET_ADDRESS> --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto -y
```
# Governance
- **Submit text proposal**
```python
babylond tx gov submit-proposal \
--title="<Your Title>" \
--description="<Your Description>" \
--deposit=1000000ubbn \
--type="Text" \
--from=<WALLET_ADDRESS> \
--gas-prices=0.1ubbn \
--gas-adjustment=1.5 \
--gas=auto \
-y
```
- **List all proposals**
```pytho
babylond query gov proposals
```
- **View proposal by id**
```python
babylond query gov proposal <proposal_id>
```
- **Vote 'Yes'**
```python
babylond tx gov vote 1 yes --from <YOUR_WALLET> --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto -y
```
- **Vote 'No'**
```python
babylond tx gov vote 1 no --from <YOUR_WALLET> --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto -y
```
- **Vote 'Abstain'**
```python
babylond tx gov vote 1 abstain --from <YOUR_WALLET> --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto -y
```
- **Vote 'NoWithVeto'**
```python
babylond tx gov vote 1 no_with_veto --from <YOUR_WALLET> --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto -y
```
# Additional utilities
- **Update ports**
```python
CUSTOM_PORT=10
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:7060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36660\"%" $HOME/.babylond/config/config.toml && \
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:10090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:10091\"%; s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:2317\"%" $HOME/.babylond/config/app.toml && \
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36657\"%" $HOME/.babylond/config/client.toml
```
**Update Indexer**
- **Disable indexer**
```python
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.babylond/config/config.toml
```
- **Enable indexer**
```python
sed -i 's|^indexer *=.*|indexer = "kv"|' $HOME/.babylond/config/config.toml
```
- **Update pruning**
```python
sed -i.bak -e 's|^pruning *=.*|pruning = "custom"|; s|^pruning-keep-recent *=.*|pruning-keep-recent = "1000"|; s|^pruning-keep-every *=.*|pruning-keep-every = "0"|; s|^pruning-interval *=.*|pruning-interval = "10"|' $HOME/.babylond/config/app.toml
```
# Maintenance
- **Get validator info**
```python
babylond status 2>&1 | jq .ValidatorInfo
```
- **Get sync info**
```python
babylond status 2>&1 | jq .SyncInfo
```
- **Get node peer**
```python
echo $(babylond tendermint show-node-id)@$(curl ifconfig.me)$(grep -A 3 "\[p2p\]" ~/.babylond/config/config.toml | egrep -o ":[0-9]+")
```
- **Check your RPC***
```python
echo -e "\033[0;32m$(grep -A 3 "\[rpc\]" ~/.babylond/config/config.toml | egrep -o ":[0-9]+")\033[0m"
```
- **Check if validator key is correct**
```python
[[ $(babylond q staking validator $(babylon keys show <YOUR_WALLET_NAME> --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(babylon status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
- **Get live peers**
```python
curl -sS http://localhost:51657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
- **Reset chain data**
```python
babylond tendermint unsafe-reset-all --home $HOME/.babylond --keep-addr-book
```
- **Check network parameters**
```python
babylond q staking params
babylond q slashing params
```
- **Remove node**
**Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your 
priv_validator_key.json!**
```python
sudo systemctl stop babylond && \
sudo systemctl disable babylond && \
sudo rm /etc/systemd/system/babylond.service && \
sudo systemctl daemon-reload && \
rm -rf $HOME/.babylond && \
rm -rf $HOME/babylond
```
# Service Management
- **Reload service configuration**
```python
sudo systemctl daemon-reload
```
- **Enable service**
```python
sudo systemctl enable babylond
```
- **Disable service**
```python
sudo systemctl disable babylond
```
- **Start service**
```python
sudo systemctl start babylond
```
- **Stop service**
```python
sudo systemctl stop babylond
```
- **Restart service**
```python
sudo systemctl restart babylond
```
- **Check service status**
```python
sudo systemctl status babylond
```
- **Check service status**
```python
sudo systemctl status babylond
```
- **Check service logs**
```python
sudo journalctl -u babylond -f -o cat
```
