# Instructions
### Stop the service and reset the data
```python
sudo systemctl stop empowerd
cp $HOME/.empowerchain/data/priv_validator_state.json $HOME/.empowerchain/priv_validator_state.json.backup
empowerd tendermint unsafe-reset-all --home $HOME/.empowerchain
```
### Get and configure the state sync information
```python
SNAP_RPC=http://rpc.empower.max-node.xyz:35057
peers="9e4aba1835f3590da434558daa3b1baeddff41dc@rpc.empower.max-node.xyz:35056"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.empowerchain/config/config.toml
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 100)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH


sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.empowerchain/config/config.toml
empowerd tendermint unsafe-reset-all --home $HOME/.empowerchain
wget -O $HOME/.empowerchain/config/addrbook.json "https://snapshots.max-node.xyz/empower/empower/addrbook.json"
curl -o - -L http://empw.wasm.stavr.tech:1001/wasm-empw.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.empowerchain --strip-components 2
```
### Restart the service and check the log
```python
systemctl restart empowerd && journalctl -u empowerd -f -o cat
```
