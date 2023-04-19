# Instructions
### Stop the service and reset the data
```python
sudo systemctl stop cascadiad
cp $HOME/.cascadiad/data/priv_validator_state.json $HOME/.cascadiad/priv_validator_state.json.backup
cascadiad tendermint unsafe-reset-all --home $HOME/.cascadiad
```
### Get and configure the state sync information
```python
STATE_SYNC_RPC=https://rpc.cascadia.max-node.xyz:443
STATE_SYNC_PEER=7b77ea69a74bf4f03d9d2b297992ecad1205cf3a@rpc.cascadia.max-node.xyz:55656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 1000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.cascadiad/config/config.toml

mv $HOME/.cascadiad/priv_validator_state.json.backup $HOME/.cascadiad/data/priv_validator_state.json
```
### Restart the service and check the log
```python
sudo systemctl start cascadiad && sudo journalctl -u cascadiad -f --no-hostname -o cat
```
