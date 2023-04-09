# Snapshot
## install dependencies, if needed
```pyton
sudo apt update
sudo apt install lz4 -y
```
## Stop the service and reset the data
```python
sudo systemctl stop nibid
cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup
rm -rf $HOME/.nibid/data
```
## Download latest snapshot
```python
curl -L https://snapshots.max-node.xyz/nibiru/nibiru-itn-1_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nibid
mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json
```
## Restart the service and check the log
```python
sudo systemctl start nibid && sudo journalctl -u nibid -f --no-hostname -o cat
```
