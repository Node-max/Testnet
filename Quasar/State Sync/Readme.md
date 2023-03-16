# State Sync Quasard
**Information:**

**Public RPC endpoint:**  [https://rpc.quasar.node-max.space/](https://rpc.quasar.node-max.space/)

# Guide to sync your node using State Sync:
**Copy the entire command**
```python
sudo systemctl stop quasard
SNAP_RPC="https://rpc.quasar.node-max.space/";

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

peers="c6a18679340e7011206d1e3e05ece1aac7a4e731@rpc.quasar.node-max.space:32656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.quasard/config/config.toml 

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.quasard/config/config.toml

mv $HOME/.quasarnode/priv_validator_state.json.backup $HOME/.quasarnode/data/priv_validator_state.json

curl -s https://snapshot.node-max.space/Quasar/wasm.lz4 | lz4 -dc - | tar -xf - -C $HOME/.quasarnode

```python
sudo systemctl restart quasard
sudo journalctl -u quasard -f --no-hostname -o cat
```
