
# Installation
## Use the script for quick installation:
```python
wget -q -O namada.sh wget -q -O namada.sh https://raw.githubusercontent.com/Node-max/Testnet/main/Namada/namada.sh && chmod +x namada.sh && sudo /bin/bash namada.sh && chmod +x namada.sh && sudo /bin/bash namada.sh
```
## Specify a name for your node and wait for the installation to complete, after full synchronization proceed to the next step:
```python
source $HOME/.bash_profile
```
## Generate keys for your account:
```python
namada wallet address gen --alias my-account
```
## Initialize the validator account:
```python
namada client init-validator \
  --alias $VALIDATOR_ALIAS \
  --source my-account \
  --commission-rate 0.1 \
  --max-commission-rate-change 0.1
```
## Requesting tokens:
```python
namadac transfer \
    --token NAM \
    --amount 1000 \
    --source faucet \
    --target $VALIDATOR_ALIAS \
    --signer $VALIDATOR_ALIAS
```
## We check the balance, if everything is fine, proceed to the next step:
```python
namada client balance --token NAM --owner $VALIDATOR_ALIAS
```
## Delegate tokens to your validator
```python
namada client bond \
  --validator $VALIDATOR_ALIAS \
  --amount 1000
```
## If you get an error “The address doesn’t belong to any known validator account” try again after a few epochs ~1 hour.

# Additionally
## View logs
```pytgon
journalctl -u namadad -f -o cat
```
## Node restart:
```python
systemctl restart namadad
```
Check node performance:
```python
curl localhost:26657/status
```
## Find out if the node is synchronized, if the result is false, then the node is synchronized
```python
curl -s localhost:26657/status | jq .result.sync_info.catching_up
```
## Ports used:
```python
26656, 26657, 26658
```
## Delete node:
```python
systemctl stop namadad
systemctl disable namadad
rm -rf ~/namada ~/.namadad /etc/systemd/system/namadad.service
```
