⚠️ save the **seed** phrase
```python
nibid keys add <YOUR_WALLET_NAME>
```
- **Recover wallet**
⚠️ save the **seed** phrase
```python
nibid keys add <YOUR_WALLET_NAME> --recover
```
- **List of all wallets**
```python
nibid keys list
```
- **Remove wallet**
```python
nibid keys delete <YOUR_WALLET_NAME>
```
- **Export wallet**
⚠️ save to wallet.backup
```python
nibid keys export <YOUR_WALLET_NAME>
```
- **Import a wallet**
```python
nibid keys import <WALLET_NAME> wallet.backup
```
- **Check the wallet balance**
```python
nibid q bank balances $(nibid keys show wallet -a)
```
# Working with the validator
```python
nibid tx staking create-validator \
--amount=1000000unibi \
--pubkey=$(nibid tendermint show-validator) \
--moniker="<Your moniker>" \
--identity=<your identity> \
--details="<Your details>" \
--chain-id=nibiru-itn-1 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=<YOUR_WALLET> \
--gas-prices=0.1unibi \
--gas-adjustment=1.5 \
--gas=auto \
-y
```
- **Edit your validator**
```python
nibid tx staking edit-validator \
--new-moniker="<Your moniker>" \
--identity=<your identity> \
--details="<Your details>" \
--chain-id=nibiru-itn-1 \
--commission-rate=0.1 \
--from=<YOUR_WALLET> \
--gas-prices=0.1unibi \
--gas-adjustment=1.5 \
--gas=auto \
-y
```
- **Get the validator out of jail**
```python
nibid tx slashing unjail --from <YOUR_WALLET> --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y
```
- **See information on blocks**
```python
nibid query slashing signing-info $(nibid tendermint show-validator)
```
- **List of active validators**
```python
nibid q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **List of inactive validators**
```python
nibid q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED") or .status=="BOND_STATUS_UNBONDING")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **View information about your validator**
```python
nibid q staking validator $(nibid keys show wallet --bech val -a)
```
# Transactions
- **Collect rewards from all validators**
```python
nibid tx distribution withdraw-all-rewards --from <YOUR_WALLET> --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y
```
- **Collect rewards and commission from your validator**
```python
nibid tx distribution withdraw-rewards $(nibid keys show wallet --bech val -a) --commission --from <YOUR_WALLET> --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y
```
- **Delegate to your validator**
```python
nibid tx staking delegate $(nibid keys show wallet --bech val -a) 1000000unibi --from <YOUR_WALLET> --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y
```
- **Delegate tokens to the validator**
```python
nibid tx staking delegate <VALOPER_ADDRESS> 1000000unibi --from <YOUR_WALLET> --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y
```
- **Redelegate tokens to another validator**
```python
nibid tx staking redelegate <SRC_VALOPER_ADDRESS> <TARGET_VALOPER_ADDRESS> 1000000unibi --from <YOUR_WALLET> --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y
```
- **Collect tokens from the validator**
⚠️ there may be a long waiting time for the tokens to arrive in the wallet
```python
nibid tx staking unbond <VALOPER_ADDRESS> 1000000unibi --from <YOUR_WALLET> --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y
```
- **Send tokens to another wallet**
```python
nibid tx bank send <YOUR_WALLET_ADDRESS> <TARGET_WALLET_ADDRESS> 1000000unibi --from <YOUR_WALLET> --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y
```
- **Verification of information on TX_HASH**
```python
nibid query tx <TX_HASH>
```
# Governance
- **Create a text proposal (proposal)**
```python
nibid tx gov submit-proposal \
--title="<Your Title>" \
--description="<Your Description>" \
--deposit=1000000unibi \
--type="Text" \
--from=<WALLET_ADDRESS> \
--gas-prices=0.1unibi \
--gas-adjustment=1.5 \
--gas=auto \
-y
```
- **List of all offers**
```python
nibid query gov proposals
```
- **View the proposal by <proposal_id>**
```python
nibid query gov proposal <proposal_id>
```
- **Vote as, YES**
```python
nibid tx gov vote 1 yes --from <YOUR_WALLET> --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y
```
- **Vote as, NO**
```python
quasard tx gov vote 1 no --from <YOUR_WALLET> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
- **Vote as, NO_WITH_VETO**
```python
nibid tx gov vote 1 no_with_veto --from <YOUR_WALLET> --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y
```
- **Vote as, ABSTAIN**
```python
nibid tx gov vote 1 abstain --from <YOUR_WALLET> --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y
```
# Additional utilities
- **Changing ports to custom**
```python
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:7060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36660\"%" $HOME/.nibid/config/config.toml && \
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:10090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:10091\"%; s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:2317\"%" $HOME/.nibid/config/app.toml && \
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36657\"%" $HOME/.nibid/config/client.toml
```
- **Enable indexing**
```python
sed -i 's|^indexer *=.*|indexer = "kv"|' $HOME/.nibid/config/config.toml
```
- **Remove indexing**
```python
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.nibid/config/config.toml
```
- **Configure prunning**
```python
sed -i.bak -e 's|^pruning *=.*|pruning = "custom"|; s|^pruning-keep-recent *=.*|pruning-keep-recent = "1000"|; s|^pruning-keep-every *=.*|pruning-keep-every = "0"|; s|^pruning-interval *=.*|pruning-interval = "10"|' $HOME/.nibid/config/app.toml
```
- **Look at your peer**
```python
echo $(nibid tendermint show-node-id)@$(curl ifconfig.me)$(grep -A 3 "\[p2p\]" ~/.nibid/config/config.toml | egrep -o ":[0-9]+")
```
- **View your RPC**
```python
echo -e "\033[0;32m$(grep -A 3 "\[rpc\]" ~/.nibid/config/config.toml | egrep -o ":[0-9]+")\033[0m"
```
- **View information about the validator**
```python
nibid status 2>&1 | jq .ValidatorInfo
```
- **See the node synchronization status (false - synced, true - not synced)**
```python
nibid status 2>&1 | jq .SyncInfo.catching_up
```
- **Check the last block**
```python
nibid status 2>&1 | jq .SyncInfo.latest_block_height
```
- **Reset network**
```python
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book
```
- **Delete a node**
```python
sudo systemctl stop nibid && \
sudo systemctl disable nibid && \
sudo rm /etc/systemd/system/nibid.service && \
sudo systemctl daemon-reload && \
rm -rf $HOME/.nibid && \
rm -rf $HOME/nibiru && \
sudo rm $(which nibid)
```
- **Get the IP address of the server**
```python
wget -qO- eth0.me
```
- **Network settings**
```python
nibid q staking params
nibid q slashing params
```
- **Update Servername (example hostname, nibiru-node)**
```python
sudo hostnamectl set-hostname <your-hostname>
```
- **Search all outgoing transactions by address**
```python
nibid q txs --events transfer.sender=<ADDRESS> 2>&1 | jq | grep txhash
```
- **Search all incoming transactions by address**
```python
nibid q txs --events transfer.recipient=<ADDRESS> 2>&1 | jq | grep txhash
```
# Service management
- **Restart services**
```python
sudo systemctl daemon-reload
```
- **Turn on the service**
```python
sudo systemctl enable nibid
```
- **Turn off the service**
```python
sudo systemctl disable nibid
```
- **Start the service**
```python
sudo systemctl start nibid
```
- **Stop the service**
```python
sudo systemctl stop nibid
```
- **Restart the service**
```python
sudo systemctl restart nibid
```
- **Check the service status**
```python
sudo systemctl status nibid
```
- **Check the service logs**
```python
sudo journalctl -u nibid -f -o cat
```
