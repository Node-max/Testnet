# Instructions
### Stop the service and reset the data
```python
sudo systemctl stop archwayd
cp $HOME/.archway/data/priv_validator_state.json $HOME/.archway/priv_validator_state.json.backup
archwayd tendermint unsafe-reset-all --home $HOME/.archway
```
### Get and configure the state sync information
```python
STATE_SYNC_RPC=https://rpc.archway.max-node.xyz:443
STATE_SYNC_PEER=8b728546d0e0e422c1cd9e9f9cb6a3e67ac3e86d@rpc.archway.max-node.xyz:15656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 1000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.archway/config/config.toml

mv $HOME/.archway/priv_validator_state.json.backup $HOME/.archway/data/priv_validator_state.json
```

### Download latest wasm
```python
curl -L https://snapshots.max-node.xyz/archway/wasm_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.archway
```
### Restart the service and check the log
```python
sudo systemctl start archwayd && sudo journalctl -u archwayd -f --no-hostname -o cat
```
