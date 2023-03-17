# Working with a wallet
- **Add new key**
```python
sourced keys add wallet
```
- **Recover existing key**
```python
sourced keys add wallet --recover
```
- **List all keys**
```python
sourced keys list
```
- **Delete key**
```python
sourced keys delete wallet
```
- **Export key to the file**
```python
sourced keys export wallet
```
- **Import key from the file**
```python
sourced keys import wallet wallet.backup
```
- **Query wallet balance**
```python
sourced q bank balances $(sourced keys show wallet -a)
```
# Working with the validator
- **Create new validator**
```python
sourced tx staking create-validator \
--amount 1000000usource \
--pubkey $(sourced tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id sourcechain-testnet \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0usource \
-y
```
- **Edit existing validator**
```python
sourced tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id sourcechain-testnet \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0usource \
-y
```
- **Unjail validator**
```python
sourced tx slashing unjail --from wallet --chain-id sourcechain-testnet --gas-adjustment 1.4 --gas auto --gas-prices 0usource -y
```
- **Jail reason**
```python
sourced query slashing signing-info $(sourced tendermint show-validator)
```
- **List all active validators**
```python
sourced q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **List all inactive validators**
```python
sourced q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- **View validator details**
```python
sourced q staking validator $(sourced keys show wallet --bech val -a)
```


