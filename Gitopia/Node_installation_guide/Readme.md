# Manual installation
### Setup validator name
```python
MONIKER="YOUR_MONIKER_GOES_HERE"
```
### Preparing the server
```python
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```
### GO 1.19
```python
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.20.2.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```
### Add Gitopia remote helper
```python
# https://docs.gitopia.com/git-remote-gitopia
curl -Ls https://get.gitopia.com | sudo bash
```
# Node installation
### Clone project repository
```python
cd $HOME
rm -rf gitopia
git clone gitopia://gitopia/gitopia
cd gitopia
git checkout v1.2.0
# Build binaries
make build
```
### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.gitopia/cosmovisor/genesis/bin
mv build/gitopiad $HOME/.gitopia/cosmovisor/genesis/bin/
rm -rf build
``` 
### Create application symlinks
```python
ln -s $HOME/.gitopia/cosmovisor/genesis $HOME/.gitopia/cosmovisor/current
sudo ln -s $HOME/.gitopia/cosmovisor/current/bin/gitopiad /usr/local/bin/gitopiad
```
# Install Cosmovisor and create a service
### Download and install Cosmovisor
```python
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```
### Create service
```python
sudo tee /etc/systemd/system/gitopiad.service > /dev/null << EOF
[Unit]
Description=gitopia-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.gitopia"
Environment="DAEMON_NAME=gitopiad"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable gitopiad
```
# Initialize the node
### Set node configuration
```python
gitopiad config chain-id gitopia-janus-testnet-2
gitopiad config keyring-backend test
gitopiad config node tcp://localhost:41657
```
### Initialize the node
```python
gitopiad init $MONIKER --chain-id gitopia-janus-testnet-2
```
### Download genesis and addrbook
```pythom
curl -Ls https://snapshots.max-node.xyz/gitopia/genesis.json > $HOME/.gitopia/config/genesis.json
curl -Ls https://snapshots.max-node.xyz/gitopia/addrbook.json > $HOME/.gitopia/config/addrbook.json
```
### Add seeds
```python
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@rpc.gitopia.max-node.xyz:50659\"|" $HOME/.gitopia/config/config.toml
```
### Set minimum gas price
```python
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.001utlore\"|" $HOME/.gitopia/config/app.toml
```
### Set pruning
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.gitopia/config/app.toml
```
### Set custom ports
```python
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:41658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:41657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:41060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:41656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":41660\"%" $HOME/.gitopia/config/config.tomlsed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:50317\"%; s%^address = \":8080\"%address = \":50080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:50090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:50091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:50545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:50546\"%" $HOME/.gitopia/config/app.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:41317\"%; s%^address = \":8080\"%address = \":41080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:41090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:41091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:41545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:41546\"%" $HOME/.gitopia/config/app.toml
```
### Download latest chain snapshot
```python
curl -L https://snapshots.max-node.xyz/gitopia/gitopia-janus-testnet-2_latest.tar.lz4  | tar -Ilz4 -xf - -C $HOME/.gitopia
[[ -f $HOME/.gitopia/data/upgrade-info.json ]] && cp $HOME/.gitopia/data/upgrade-info.json $HOME/.gitopia/cosmovisor/genesis/upgrade-info.json
```
### Start service and check the logs
```python
sudo systemctl start gitopiad && sudo journalctl -u gitopiad -f --no-hostname -o cat
```
