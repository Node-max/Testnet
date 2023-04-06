![nolus](https://user-images.githubusercontent.com/44331529/209941074-e137b77b-3d27-4e3d-a338-a773460b8a6c.png)
[WebSite](https://nolus.io) 
[GitHub](https://github.com/Nolus-Protocol/nolus-core) 
[Discord](https://discord.gg/nolus-protocol)
=

# RPC
```python
https://rpc.nolus-test.max-node.xyz/
```
# API
```python
https://api.nolus-test.max-node.xyz/
```
# gRpc
```python
https://grpc.nolus-test.max-node.xyz/
```

- **if you want to create RPC, API [HOW-TO-MAKE-RPC-API](https://github.com/Node-max/HOW-TO-MAKE-RPC-API)**

# Manual installation
```python
MONIKER="YOUR_MONIKER_GOES_HERE"
```
### Preparing the server
```python
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```
- **Installing GO**
```python
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.20.2.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```
# Node installation
### Clone project repository
**Clone the project repository with the node, go to the project folder and collect the binary files**
```python
cd $HOME
rm -rf nolus-core
git clone https://github.com/Nolus-Protocol/nolus-core.git
cd nolus-core
git checkout v0.2.2
### Build binaries
make build
```
### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.nolus/cosmovisor/genesis/bin
mv target/release/nolusd $HOME/.nolus/cosmovisor/genesis/bin/
rm -rf build
```
# Create application symlinks
```python
ln -s $HOME/.nolus/cosmovisor/genesis $HOME/.nolus/cosmovisor/current
sudo ln -s $HOME/.nolus/cosmovisor/current/bin/nolusd /usr/local/bin/nolusd
```
# Install Cosmovisor and create a service
### Download and install Cosmovisor
```python
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```
### Create service
```python
sudo tee /etc/systemd/system/nolusd.service > /dev/null << EOF
[Unit]
Description=nolus-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.nolus"
Environment="DAEMON_NAME=nolusd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.nolus/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable nolusd
```
# Initialize the node
### Set node configuration
```python
nolusd config chain-id nolus-rila
nolusd config keyring-backend test
nolusd config node tcp://localhost:43657
```
### Initialize the node
```python
nolusd init $MONIKER --chain-id nolus-rila
```
### Download genesis and addrbook
```python
curl -Ls https://snapshot.max-node.xyz/nolus/config/genesis.json
curl -Ls https://snapshot.max-node.xyz/nolus/config/addrbook.json
```
### Add seeds
```python
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@rpc.nolus-test.max-node.xyz:43657\"|" $HOME/.nolus/config/config.toml
```
### Set minimum gas price
```python
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0025unls\"|" $HOME/.nolus/config/app.toml
```
### Set pruning
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "nothing"|' \
  $HOME/.nolus/config/app.toml
```
### Set custom ports
```python
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:43658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:43657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:43060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:43656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":43660\"%" $HOME/.nolus/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://
```
# Download latest chain snapshot
```python
curl -L https://snapshot.max-node.xyz/nolus/snapshot.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nolus
[[ -f $HOME/.nolus/data/upgrade-info.json ]] && cp $HOME/.nolus/data/upgrade-info.json $HOME/.nolus/cosmovisor/genesis/upgrade-info.json
```
### Start service and check the logs
```python
sudo systemctl start nolusd && sudo journalctl -u nolusd -f --no-h
```



