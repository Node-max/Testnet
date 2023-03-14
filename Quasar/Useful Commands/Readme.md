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
