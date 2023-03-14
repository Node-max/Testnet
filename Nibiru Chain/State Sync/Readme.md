```python
sudo systemctl stop nibid
```
```python
cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book

SNAP_RPC="https://rpc-nibiru.max-node.xyz:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

PEERS="f8b421cde8b1bb1b1d3efa5c5cdafe58ce0813e9@rpc-nibiru.max-node.xyz:34656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.nibid/config/config.toml

sed -i 's|^enable *=.*|enable = true|' $HOME/.nibid/config/config.toml
sed -i 's|^rpc_servers *=.*|rpc_servers = "'$SNAP_RPC,$SNAP_RPC'"|' $HOME/.nibid/config/config.toml
sed -i 's|^trust_height *=.*|trust_height = '$BLOCK_HEIGHT'|' $HOME/.nibid/config/config.toml
sed -i 's|^trust_hash *=.*|trust_hash = "'$TRUST_HASH'"|' $HOME/.nibid/config/config.toml

mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json
```
```python
curl -s https://snapshot.max-node.xyz/nibiru/wasm.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nibid/data
```
```python
sudo systemctl restart nibid
sudo journalctl -u nibid -f --no-hostname -o cat
```
