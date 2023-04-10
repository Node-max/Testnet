# Snapshop
## install dependencies, if needed
```python
sudo apt update
sudo apt install lz4 -y
```
## Stop the service and reset the data
```python
sudo systemctl stop defundd
cp $HOME/.defund/data/priv_validator_state.json $HOME/.defund/priv_validator_state.json.backup
rm -rf $HOME/.defund/data
```
## Download latest snapshot
```python
curl -L https://snapshot.max-node.xyz/defund/_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.defund
mv $HOME/.defund/priv_validator_state.json.backup $HOME/.defund/data/priv_validator_state.json
```
## Restart the service and check the log
```python
sudo systemctl start defundd && sudo journalctl -u defundd -f --no-hostname -o cat
```

