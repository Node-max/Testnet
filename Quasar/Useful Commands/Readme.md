# Working with a wallet
- **Create a wallet**
⚠️ save the **seed** phrase
```python
quasard keys add <YOUR_WALLET_NAME>
```
- **Recover wallet**
⚠️ save the **seed** phrase
```python
Recover wallet
```
- **List of all wallets**
```python
quasard keys list
```
- **Remove wallet**
```python
quasard keys delete <YOUR_WALLET_NAME>
```
- **Export wallet**
⚠️ save to wallet.backup
```python
quasard keys export <YOUR_WALLET_NAME>
```
- **Import a wallet**
```python
quasard keys import <WALLET_NAME> wallet.backup
```
- **Check the wallet balance**
```python
quasard q bank balances $(quasard keys show wallet -a)
```
# Working with the validator
```python
quasard tx staking create-validator \
--amount=1000000uqsr \
--pubkey=$(quasard tendermint show-validator) \
--moniker="<Your moniker>" \
--identity=<your identity> \
--details="<Your details>" \
--chain-id=qsr-questnet-04 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=<YOUR_WALLET> \
--gas-prices=0.1uqsr \
--gas-adjustment=1.5 \
--gas=auto \
-y
```
- **Edit your validator**
```python
quasard tx staking edit-validator \
--new-moniker="<Your moniker>" \
--identity=<your identity> \
--details="<Your details>" \
--chain-id=qsr-questnet-04 \
--commission-rate=0.1 \
--from=<YOUR_WALLET> \
--gas-prices=0.1uqsr \
--gas-adjustment=1.5 \
--gas=auto \
-y
```
- **Get the validator out of jail**
```python
quasard tx slashing unjail --from <YOUR_WALLET> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
- **See information on blocks**
```python
quasard query slashing signing-info $(quasard tendermint show-validator)
```
- **List of active validators**
```python
quasard q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **List of inactive validators**
```python
quasard q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED") or .status=="BOND_STATUS_UNBONDING")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **View information about your validator**
```python
quasard q staking validator $(quasard keys show wallet --bech val -a)
```
# Transactions
- **Collect rewards from all validators**
```python
quasard tx distribution withdraw-all-rewards --from <YOUR_WALLET> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
- **Collect rewards and commission from your validator**
```python
quasard tx distribution withdraw-rewards $(quasard keys show wallet --bech val -a) --commission --from <YOUR_WALLET> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
- **Delegate to your validator**
```python
quasard tx staking delegate $(quasard keys show wallet --bech val -a) 1000000uqsr --from <YOUR_WALLET> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
- **Delegate tokens to the validator**
```python
quasard tx staking delegate <VALOPER_ADDRESS> 1000000uqsr --from <YOUR_WALLET> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
- **Redelegate tokens to another validator**
```python
quasard tx staking redelegate <SRC_VALOPER_ADDRESS> <TARGET_VALOPER_ADDRESS> 1000000uqsr --from <WALLET> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
- **Collect tokens from the validator**
⚠️ there may be a long waiting time for the tokens to arrive in the wallet
```python
quasard tx staking unbond <VALOPER_ADDRESS> 1000000uqsr --from <YOUR_WALLET> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
- **Send tokens to another wallet**
```python
quasard tx bank send <YOUR_WALLET_ADDRESS> <TARGET_WALLET_ADDRESS> 1000000uqsr --from <YOUR_WALLET_ADDRESS> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
- **Verification of information on TX_HASH**
```python
quasard query tx <TX_HASH>
```
# Governance
- **Create a text proposal (proposal)**
```python
quasard tx gov submit-proposal \
--title="<Your Title>" \
--description="<Your Description>" \
--deposit=1000000unibi \
--type="Text" \
--from=<WALLET_ADDRESS> \
--gas-prices=0.1uqsr \
--gas-adjustment=1.5 \
--gas=auto \
-y
```
- **List of all offers**
```python
quasard query gov proposals
```
- **View the proposal by <proposal_id>**
```python
quasard query gov proposal <proposal_id>
```
- **Vote as, YES**
```python
quasard tx gov vote 1 yes --from <YOUR_WALLET> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
- **Vote as, NO**
```python
quasard tx gov vote 1 no --from <YOUR_WALLET> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
- **Vote as, NO_WITH_VETO**
```python
quasard tx gov vote 1 no_with_veto --from <YOUR_WALLET> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
- **Vote as, ABSTAIN**
```python
quasard tx gov vote 1 abstain --from <YOUR_WALLET> --chain-id qsr-questnet-04 --gas-prices 0.1uqsr --gas-adjustment 1.5 --gas auto -y
```
# Additional utilities
- **Changing ports to custom**
```python
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:7060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36660\"%" $HOME/.quasarnode/config/config.toml && \
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:10090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:10091\"%; s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:2317\"%" $HOME/.quasarnode/config/app.toml && \
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36657\"%" $HOME/.quasarnode/config/client.toml
```
- **Enable indexing**
```python
sed -i 's|^indexer *=.*|indexer = "kv"|' $HOME/.quasarnode/config/config.toml
```
- **Remove indexing**
```python
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.quasarnode/config/config.toml
```
- **Configure prunning**
```python
sed -i.bak -e 's|^pruning *=.*|pruning = "custom"|; s|^pruning-keep-recent *=.*|pruning-keep-recent = "1000"|; s|^pruning-keep-every *=.*|pruning-keep-every = "0"|; s|^pruning-interval *=.*|pruning-interval = "10"|' $HOME/.quasarnode/config/app.toml
```
- **Look at your peer**
```python
echo $(quasard tendermint show-node-id)@$(curl ifconfig.me)$(grep -A 3 "\[p2p\]" ~/.quasarnode/config/config.toml | egrep -o ":[0-9]+")
```
- **View your RPC**
```python
echo -e "\033[0;32m$(grep -A 3 "\[rpc\]" ~/.quasarnode/config/config.toml | egrep -o ":[0-9]+")\033[0m"
```
- **View information about the validator**
```python
quasard status 2>&1 | jq .ValidatorInfo
```
- **See the node synchronization status (false - synced, true - not synced)**
```python
quasard status 2>&1 | jq .SyncInfo.catching_up
```
- **Check the last block**
```python
quasard status 2>&1 | jq .SyncInfo.latest_block_height
```
- **Reset network**
```python
quasard tendermint unsafe-reset-all --home $HOME/.quasarnode --keep-addr-book
```
- **Delete a node**
```python
sudo systemctl stop quasard && \
sudo systemctl disable quasard && \
sudo rm /etc/systemd/system/quasard.service && \
sudo systemctl daemon-reload && \
rm -rf $HOME/.quasarnode && \
rm -rf $HOME/quasar && \
sudo rm $(which quasard)
```
- **Get the IP address of the server**
```python
wget -qO- eth0.me
```
- **Network settings**
```python
quasard q staking params
quasard q slashing params
```
- **Update Servername (example hostname, nibiru-node)**
```python
sudo hostnamectl set-hostname <your-hostname>
```
- **Search all outgoing transactions by address**
```python
quasard q txs --events transfer.sender=<ADDRESS> 2>&1 | jq | grep txhash
```
- **Search all incoming transactions by address**
```python
quasard q txs --events transfer.recipient=<ADDRESS> 2>&1 | jq | grep txhash
```
# Service management
- **Restart services**
```python
sudo systemctl daemon-reload
```
- **Turn on the service**
```python
sudo systemctl enable quasard
```
- **Turn off the service**
```python
sudo systemctl disable quasard
```
- **Start the service**
```python
sudo systemctl start quasard
```
- **Stop the service**
```python
sudo systemctl stop quasard
```
- **Restart the service**
```python
sudo systemctl restart quasard
```
- **Check the service status**
```python
sudo systemctl status quasard
```
- **Check the service logs**
```python
sudo journalctl -u quasard -f -o cat
```

