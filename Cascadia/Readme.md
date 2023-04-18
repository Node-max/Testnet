# Chain ID: cascadia_6102-1 | Latest Version Tag: v0.1.1 
# [Website](https://www.cascadia.foundation/) | [Discord](https://discord.gg/cascadia) | [Twitter](https://twitter.com/CascadiaSystems)

# Chain explorer
https://testnet.cascadia.explorers.guru/

# Public endpoints
api: https://api.cascadia.max-node.xyz \
rpc: https://rpc.cascadia.max-node.xyz \
grpc: grpc.cascadia.max-node.xyz:55090

# Peering
### state-sync
```python
7b77ea69a74bf4f03d9d2b297992ecad1205cf3a@rpc.cascadia.max-node.xyz:55656
```

### addrbook
```python
curl -Ls https://snapshots.max-node.xyz/cascadia/addrbook.json > $HOME/.cascadiad/config/addrbook.json
```
### genesis
```python
curl -Ls https://snapshots.max-node.xyz/cascadia/genesis.json > $HOME/.cascadiad/config/genesis.json
```

### live-peers
```python
peers="ea1735fb9d6f31968f9b6288699ffd249c5eb7a0@142.132.207.187:26656,f075e82ca89acfbbd8ef845c95bd3d50574904f5@159.69.110.238:36656,001933f36a6ec7c45b3c4cef073d0372daa5344d@194.163.155.84:49656,5d563f5d882904f89b929fde2d1cf2342c8cba7c@185.209.223.64:36656,de11c79dab6ea248fb72f9d93c2ff0eace14a5ac@94.250.201.130:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:55656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.cascadiad/config/config.toml
```

