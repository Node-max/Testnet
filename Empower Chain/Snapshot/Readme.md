# Snapshot

### install dependencies, if needed
```pyton
sudo apt update
sudo apt install lz4 -y
```
## Instructions
Stop the service and reset the data
```python
sudo systemctl stop emprowed
cp $HOME/.empowerchain/data/priv_validator_state.json $HOME/.empowerchain/priv_validator_state.json.backup
rm -rf $HOME/.empowerchain/data
```
## Download latest snapshot
```python
curl -L https://snapshots.max-node.xyz/.empower/_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.empowerchain
mv $HOME/.empowerchain/priv_validator_state.json.backup $HOME/.empowerchain/data/priv_validator_state.json
```
## Restart the service and check the log
```python
sudo systemctl start empowerd && sudo journalctl -u empowerd -f --no-hostname -o cat
```
