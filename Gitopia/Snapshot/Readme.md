# Snapshot

### install dependencies, if needed
```pyton
sudo apt update
sudo apt install lz4 -y
```
## Instructions
Stop the service and reset the data
```python
sudo systemctl stop gitopiad
cp $HOME/.gitopia/data/priv_validator_state.json $HOME/.gitopia/priv_validator_state.json.backup
rm -rf $HOME/.gitopia/data
```
## Download latest snapshot
```python
curl -L https://snapshots.max-node.xyz/gitopia/gitopia-janus-testnet-2_latest.tar.lz4  | tar -Ilz4 -xf - -C $HOME/.gitopia
mv $HOME/.gitopia/priv_validator_state.json.backup $HOME/.gitopia/data/priv_validator_state.json
```
## Restart the service and check the log
```python
sudo systemctl start gitopiad && sudo journalctl -u gitopiad -f --no-hostname -o cat
```
