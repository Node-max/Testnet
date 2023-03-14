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
