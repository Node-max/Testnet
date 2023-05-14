# Instructions
### Stop the service and reset the data
```python
sudo systemctl stop andromedad
cp $HOME/.andromedad/data/priv_validator_state.json $HOME/.andromedad/priv_validator_state.json.backup
andromedad tendermint unsafe-reset-all --home $HOME/.andromedad
```
### Get and configure the state sync information
```python
STATE_SYNC_RPC=https://andromeda-testnet.rpc.kjnodes.com:443
STATE_SYNC_PEER=fec2ab9726f87d68d4f37f8c66cb852a2f6ce0c2@rpc.andromeda.max-node.xyz:47656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 1000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.andromedad/config/config.toml

mv $HOME/.andromedad/priv_validator_state.json.backup $HOME/.andromedad/data/priv_validator_state.json
```

### Download latest wasm
```python
curl -L https://snapshots.max-node.xyz/andromeda/wasm_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.andromedad
```
### Restart the service and check the log
```python
sudo systemctl start andromedad && sudo journalctl -u andromedad -f --no-hostname -o cat
```
