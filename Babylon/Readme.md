# Chain ID: bbn-test1 | Latest Version Tag: v0.5.0
# [Website](https://www.babylonchain.io/) | [Discord](https://discord.gg/babylonchain) | [Twitter](https://twitter.com/babylon_chain)

# [My Validator](https://babylon.explorers.guru/validator/bbnvaloper1x4d4d05ulwgda6y63mep7pxavs6z4rcglw4ka4)

# Public endpoints
api: https://api.babylon.max-node.xyzz \
rpc: https://rpc.babylon.max-node.xyz \
grpc: grpc.babylon.max-node.xyz:9690

# Peering
### state-sync
```python
3d8c866fc1d5f35a472d4ffdb4e6304df985de9e@rpc.babylon.max-node.xyz:32656
```

### addrbook
```python
curl -Ls https://snapshots.max-node.xyz/babylon/addrbook.json > $HOME/.babylond/config/addrbook.json
```
### genesis
```python
curl -Ls https://snapshots.max-node.xyz/babylon/genesis.json > $HOME/.babylond/config/genesis.json
```

### live-peers
```python
peers="f74f8c78f680dfddeb15158b5019c839b9e0db39@144.76.164.139:14656,59e1018b67a6c012d0b89c7936db344f5e0c7d40@65.109.26.21:14656,8092b6641a0e195fe70d890459bafae26988708a@95.216.217.29:26656,b53302c8887d4bd57799992592a2280987d3f213@95.217.144.107:20656,db7109e0a27526cdfe97c5da55b72a61937e2c13@38.242.207.130:29656,617b10a9ea1c97b8230ccb70e1fb4ecef1b46601@18.212.224.149:26656,88bed747abef320552d84d02947d0dd2b6d9c71c@65.21.200.54:44656,539bbebeb0d13ac22db640b102235f7e4f00856d@104.244.208.243:20656,6778949d8989cb957bbe337c833e2b71982dcd36@91.107.196.232:30656,c1b0694cd7725dbfa786a63fbd7b3ffb4f165b1c@144.76.201.43:26356"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.babylond/config/config.toml
```


