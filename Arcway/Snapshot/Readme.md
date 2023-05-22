# Snapshot

### install dependencies, if needed
```pyton
sudo apt update
sudo apt install lz4 -y
```
## Instructions
Stop the service and reset the data
```python
sudo systemctl stop archwayd
cp $HOME/.archway/data/priv_validator_state.json $HOME/.archway/priv_validator_state.json.backup
rm -rf $HOME/.archway/data
```
## Download latest snapshot
```python
curl -L https://snapshots.max-node.xyz/archway/constantine-3_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.archway
mv $HOME/.archway/priv_validator_state.json.backup $HOME/.archway/data/priv_validator_state.json
```
## Restart the service and check the log
```python
sudo systemctl start archwayd && sudo journalctl -u archwayd -f --no-hostname -o cat
```
