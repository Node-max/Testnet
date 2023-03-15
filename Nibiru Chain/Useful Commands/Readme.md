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
