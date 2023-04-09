## [WEBSITE](https://lavanet.xyz/) / [DISCORT](https://discord.gg/lavanetxyz) / [TWITER](https://twitter.com/lavanetxyz) / [MEDIUM](https://medium.com/lava-network) / [DOC](https://docs.lavanet.xyz/)
# RPC
```python
https://rpc.lava.max-node.xyz
```
# API
```python
https://api.lava.max-node.xyz
```
# gRPC
```python
https://grpc.lava.max-node.xyz
```

# Chain ID: lava-testnet-1 | Latest Version Tag: v0.8.1 
# [Website](https://lavanet.xyz/) | [Discord](https://discord.gg/MFVXjqqC) | [Twitter](https://twitter.com/lavanetxyz)

# Chain explorer
https://lava.explorers.guru/

# Public endpoints
api: https://api.lava.max-node.xyz \
rpc: https://rpc.lava.max-node.xyz \
grpc: https://grpc.lava.max-node.xyz


# Peering
### state-sync
```python
5e405a9e30847d5c3d975e772d2698e9122fc491@rpc.lava.max-node.xyz:44656
```

### addrbook
```python
curl -Ls https://snapshots.max-node.xyz/lava/addrbook.json > $HOME/.lava/config/addrbook.json
```

### live-peers
```python
peers="24a2bb2d06343b0f74ed0a6dc1d409ce0d996451@188.40.98.169:27656,c44a02dba51e23ac06b006fb1285988c89051ce7@85.10.198.171:26556,035d086cc418352aba9e679e079f17391791ccc6@178.208.252.54:27656,6ba3b6ec03839afffa64c83e18ff80a681f4968d@65.108.194.40:21756,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:44656,25da069c4dca143029ddae47bf2b7de69c2a8678@65.108.9.164:21156,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@34.246.190.1:26656,d6a116d2aed64bd2f383b894e38f2a62232e44b7@116.202.161.165:36656,f642b376722d6ce104ffd4c204e78ffe811e16c3@5.75.230.221:26656,3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@3.252.219.158:26656,95a490b4cde4c5311f7d58c3e47ee41fa039ddf4@144.76.27.79:60756,fb2b9d41678f3d1c9c0bdef1a87f2037b6b0088a@146.19.24.252:26666,5b25ec3860445e50a41a80850970b3241350df72@194.233.90.134:26656,e1c09e10296de98d5637e0f948ada9d477ad4d75@31.42.191.74:36656,acc3fe0b067e10b55c060b2f740d6193bf15a315@15.204.207.179:26656,5f04e56cabc20ab2e94b03022f024a310dfdf840@85.10.198.169:11656,64df498c92b9ccaf78012229d399aa34a014f087@65.109.122.105:56659,433be6210ad6350bebebad68ec50d3e0d90cb305@217.13.223.167:60856,a2480ab9265e80d3d819f27a429118b9ca39cac4@84.238.139.106:26656,1f704611e8aa4a53504fac1b80eb55c876dae8bd@65.108.13.154:30656,5ed48f1abdd16d62f2179af31af3789ac5a42ecc@34.142.220.216:37656,eb7832932626c1c636d16e0beb49e0e4498fbd5e@65.108.231.124:20656,14ae45e7f2ff7491cfa686a8fcac7cc095bc38ff@213.239.217.52:39656,b753a011d9a51bc3aa8d9301afb6d427f758a330@168.119.124.188:26656,4732ed188fbe7603f81d9f4c825397277bb72217@5.75.235.195:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.lava/config/config.toml
```
