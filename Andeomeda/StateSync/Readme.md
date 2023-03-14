# State Sync Andromeda protocol 
**Information:**

**Public RPC endpoint:**  [https://rpc.andromeda.node-max.space/](https://rpc.andromeda.node-max.space/)

# Guide to sync your node using State Sync:
**Copy the entire command**
```python
cp $HOME/.andromedad/data/priv_validator_state.json $HOME/.andromedad/priv_validator_state.json.backup
andromedad tendermint unsafe-reset-all --home $HOME/.andromedad --keep-addr-book

SNAP_RPC="https://rpc.andromeda.node-max.space:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

peers="297a09dd5d004cf36ce844bd0049756a83ab54cd@rpc.andromeda.node-max.space:26656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.andromedad/config/config.toml 

sed -i 's|^enable *=.*|enable = true|' $HOME/.andromedad/config/config.toml
sed -i 's|^rpc_servers *=.*|rpc_servers = "'$SNAP_RPC,$SNAP_RPC'"|' $HOME/.andromedad/config/config.toml
sed -i 's|^trust_height *=.*|trust_height = '$BLOCK_HEIGHT'|' $HOME/.andromedad/config/config.toml
sed -i 's|^trust_hash *=.*|trust_hash = "'$TRUST_HASH'"|' $HOME/.andromedad/config/config.toml

mv $HOME/.andromedad/priv_validator_state.json.backup $HOME/.andromedad/data/priv_validator_state.json

curl -s https://snapshot.node-max.space/andromeda/wasm.lz4 | lz4 -dc - | tar -xf - -C $HOME/.andromedad

```python
sudo systemctl restart andromedad
sudo journalctl -u andromedad -f --no-hostname -o cat
```
