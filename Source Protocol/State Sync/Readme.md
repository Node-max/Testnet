```python
sudo systemctl stop sourced
sourced unsafe-reset-all --home $HOME/.source
```
```python
PEERS="aad92fcdcba7855b9e815b038538532032004361@rpc.source.max-node.xyz:28657"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.source/config/config.toml
RPC="http://rpc.source.max-node.xyz:28657/"
LAST_HEIGHT=$(curl -s $RPC/block | jq -r .result.block.header.height)
TRUST_HEIGHT=$((LAST_HEIGHT - 1000))
TRUST_HASH=$(curl -s "$RPC/block?height=$TRUST_HEIGHT" | jq -r .result.block_id.hash)
echo $LAST_HEIGHT $TRUST_HEIGHT $TRUST_HASH
```
```python
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$RPC,$RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$TRUST_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.source/config/config.toml
```
```python
sudo systemctl restart sourced
sudo journalctl -u sourced -f -o cat
```

