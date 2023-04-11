# Snapshop
## install dependencies, if needed
```python
sudo apt update
sudo apt install lz4 -y
```
## Stop the service and reset the data
```python
sudo systemctl stop babylond
cp $HOME/.babylond/data/priv_validator_state.json $HOME/.babylond/priv_validator_state.json.backup
rm -rf $HOME/.babylond/data
```
## Download latest snapshot
```python
curl -L https://snapshots.max-node.xyz/babylon/bbn-test1_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.babylond
mv $HOME/.babylond/priv_validator_state.json.backup $HOME/.babylond/data/priv_validator_state.json
```
## Restart the service and check the log
```python
sudo systemctl restart babylond && sudo journalctl -u babylond -f -o cat
```

