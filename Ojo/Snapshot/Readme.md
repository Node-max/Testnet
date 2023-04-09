# Snapshot

### install dependencies, if needed
```pyton
sudo apt update
sudo apt install lz4 -y
```
## Instructions
Stop the service and reset the data
```python
sudo systemctl stop ojod
cp $HOME/.ojo/data/priv_validator_state.json $HOME/.ojo/priv_validator_state.json.backup
rm -rf $HOME/.ojo/data
```
## Download latest snapshot
```python
curl -L https://snapshots.max-node.xyz/ojo/ojo-devnet_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.ojo
mv $HOME/.ojo/priv_validator_state.json.backup $HOME/.ojo/data/priv_validator_state.json
```
## Restart the service and check the log
```python
sudo systemctl start ojod && sudo journalctl -u ojod -f --no-hostname -o cat
```
