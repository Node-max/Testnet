# State Sync Andromeda protocol 
**Information:**

**Public RPC endpoint:**  [https://rpc.andromeda.max-node.xyz/](https://rpc.andromeda.max-node.xyz/) \

# Guide to sync your node using State Sync:
**Copy the entire command**
```python
sudo systemctl stop andromedad
SNAP_RPC="https://andromeda-testnet.rpc.l0vd.com"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.andromedad/config/config.toml

peers="3d7973758b48ba80b885069b020db503b7a75dde@95.216.2.219:26656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.andromedad/config/config.toml 

andromedad tendermint unsafe-reset-all --home ~/.andromedad --keep-addr-book && sudo systemctl restart andromedad && \
journalctl -u andromedad -f --output cat
```

**Turn off State Sync Mode after synchronization**
```python
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.andromedad/config/config.toml
```
