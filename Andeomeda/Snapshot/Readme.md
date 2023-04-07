# Snapshot

### install dependencies, if needed
```pyton
sudo apt update
sudo apt install lz4 -y
```
## Instructions
Stop the service and reset the data
```python
sudo systemctl stop andromedad
cp $HOME/.andromedad/data/priv_validator_state.json $HOME/.andromedad/priv_validator_state.json.backup
rm -rf $HOME/.andromedad/data
```
## Download latest snapshot
```python
curl -L https://snapshots.max-node.xyz/andromeda/snapshot_latest.tar | tar -xf - -C $HOME/.andromedad
mv $HOME/.andromedad/priv_validator_state.json.backup $HOME/.andromedad/data/priv_validator_state.json
```
## Restart the service and check the log
```python
sudo systemctl start andromedad && sudo journalctl -u andromedad -f --no-hostname -o cat
```
