# Instructions
- **Stop the service and reset the data**
```python
sudo systemctl stop sourced
cp $HOME/.source/data/priv_validator_state.json $HOME/.source/priv_validator_state.json.backup
rm -rf $HOME/.source/data
```
- **Download latest snapshot**
```python
curl -L https://snapshots.max-node.xyz/source/sourcechain-testnet_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.source
mv $HOME/.source/priv_validator_state.json.backup $HOME/.source/data/priv_validator_state.json
```
- **Restart the service and check the log**
```python
sudo systemctl start sourced && sudo journalctl -u sourced -f --no-hostname -o cat
````
