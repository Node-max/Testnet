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
# Node installation
### Clone project repository
```python
cd $HOME
rm -rf source
git clone https://github.com/Source-Protocol-Cosmos/source.git
cd source
git checkout e06b810e842e57ec8f5432c9cdd57883a69b3cee
# Build binaries
make build
```
### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.source/cosmovisor/genesis/bin
mv bin/sourced $HOME/.source/cosmovisor/genesis/bin/
rm -rf build
``` 
### Create application symlinks
```python
ln -s $HOME/.source/cosmovisor/genesis $HOME/.source/cosmovisor/current
sudo ln -s $HOME/.source/cosmovisor/current/bin/sourced /usr/local/bin/sourced
```
# Install Cosmovisor and create a service
### Download and install Cosmovisor
```python
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```
### Create service
```python
sudo tee /etc/systemd/system/sourced.service > /dev/null << EOF
[Unit]
Description=source-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.source"
Environment="DAEMON_NAME=sourced"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable sourced
```
# Initialize the node
### Set node configuration
```python
sourced config chain-id sourcechain-testnet
sourced config keyring-backend test
sourced config node tcp://localhost:28657
```
### Initialize the node
```python
sourced init $MONIKER --chain-id sourcechain-testnet
```
### Download genesis and addrbook
```pythom
curl -Ls https://snapshots.max-node.xyz/source/genesis.json > $HOME/.source/config/genesis.json
curl -Ls https://snapshots.max-node.xyz/source/addrbook.json > $HOME/.source/config/addrbook.json
```
### Add seeds
```python
sed -i -e "s|^seeds *=.*|seeds = \"8574b64414e446621dc9ad09bc25dd328cb6aa2d@rpc.source.max-node.xyz:28656\"|" $HOME/.source/config/config.toml
```
### Set minimum gas price
```python
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0usource\"|" $HOME/.source/config/app.toml
```
### Set pruning
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.source/config/app.toml
```
### Set custom ports
```python
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:28658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:28657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:28060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:28656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":28660\"%" $HOME/.source/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:28317\"%; s%^address = \":8080\"%address = \":28080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:28090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:28091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:28545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:28546\"%" $HOME/.source/config/app.toml
```
### Download latest chain snapshot
```python
curl -L https://snapshots.max-node.xyz/source/sourcechain-testnet_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.lava
[[ -f $HOME/.source/data/upgrade-info.json ]] && cp $HOME/.source/data/upgrade-info.json $HOME/.source/cosmovisor/genesis/upgrade-info.json
```
### Start service and check the logs
```python
sudo systemctl start sourced && sudo journalctl -u sourced -f --no-hostname -o cat
```
