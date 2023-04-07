# Instructions
### Stop the service and reset the data
```python
sudo systemctl stop lavad
cp $HOME/.lava/data/priv_validator_state.json $HOME/.lava/priv_validator_state.json.backup
rm -rf $HOME/.lava/data
```
### Download latest snapshot
```python
curl -L https://snapshots.max-node.xyz/lava/lava_latest.tar | tar -xf - -C $HOME/.lava
mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json
```
### Restart the service and check the log
```python
sudo systemctl start lavad && sudo journalctl -u lavad -f --no-hostname -o cat
```
