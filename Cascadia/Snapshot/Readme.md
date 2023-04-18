# Snapshot

### install dependencies, if needed
```pyton
sudo apt update
sudo apt install lz4 -y
```
## Instructions
Stop the service and reset the data
```python
sudo systemctl stop cascadiad
cp $HOME/.cascadiad/data/priv_validator_state.json $HOME/.cascadiad/priv_validator_state.json.backup
rm -rf $HOME/.cascadiad/data
```
## Download latest snapshot
```python
curl -L https://snapshots.max-node.xyz/cascadia/cascadia_6102-1_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.cascadiad
mv $HOME/.cascadiad/priv_validator_state.json.backup $HOME/.cascadiad/data/priv_validator_state.json
```
## Restart the service and check the log
```python
sudo systemctl start cascadiad && sudo journalctl -u cascadiad -f --no-hostname -o cat
```
