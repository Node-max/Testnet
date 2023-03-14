# State Sync Quasard
**Information:**

**Public RPC endpoint:**  [https://rpc.quasar.node-max.space/](https://rpc.quasar.node-max.space/)

# Guide to sync your node using State Sync:
**Copy the entire command**
```python
sudo systemctl stop quasard
SNAP_RPC="https://rpc.quasar.node-max.space/"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.quasard/config/config.toml

peers="c6a18679340e7011206d1e3e05ece1aac7a4e731@rpc.quasar.node-max.space:32656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.quasard/config/config.toml 

quasard tendermint unsafe-reset-all --home ~/.quasard --keep-addr-book && sudo systemctl restart quasard && \
journalctl -u quasard -f --output cat
```

**Turn off State Sync Mode after synchronization**
```python
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.quasard/config/config.toml
```
