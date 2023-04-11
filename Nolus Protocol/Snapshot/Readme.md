# Snapshot

## install dependencies, if needed
```pyton
sudo apt update
sudo apt install lz4 -y
```
## Stop the service and reset the data
```python
sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
rm -rf $HOME/.nolus/data
```
## Download latest snapshot
```python
curl -L https://snapshot.max-node.xyz/nolus/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nolus
mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json
```
## Restart the service and check the log
```python
sudo systemctl start nolusd && sudo journalctl -u nolusd -f --no-hostname -o cat
```
