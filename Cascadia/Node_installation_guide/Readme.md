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
rm -rf cascadia
git clone https://github.com/CascadiaFoundation/cascadia.git
cd cascadia
git checkout v0.1.1
# Build binaries
make build
```
### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.cascadiad/cosmovisor/genesis/bin
mv build/cascadiad $HOME/.cascadiad/cosmovisor/genesis/bin/
rm -rf build
``` 
### Create application symlinks
```python
ln -s $HOME/.cascadiad/cosmovisor/genesis $HOME/.cascadiad/cosmovisor/current
sudo ln -s $HOME/.cascadiad/cosmovisor/current/bin/cascadiad /usr/local/bin/cascadiad
```
# Install Cosmovisor and create a service
### Download and install Cosmovisor
```python
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```
### Create service
```python
sudo tee /etc/systemd/system/cascadiad.service > /dev/null << EOF
[Unit]
Description=cascadia-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.cascadiad"
Environment="DAEMON_NAME=cascadiad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.cascadiad/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable cascadiad
```
# Initialize the node
### Set node configuration
```python
cascadiad config chain-id cascadia_6102-1
cascadiad config keyring-backend test
cascadiad config node tcp://localhost:55657
```
### Initialize the node
```python
cascadiad init $MONIKER --chain-id cascadia_6102-1
```
### Download genesis and addrbook
```pythom
curl -Ls https://snapshots.max-node.xyz/cascadia/genesis.json > $HOME/.cascadiad/config/genesis.json
curl -Ls https://snapshots.max-node.xyz/cascadia/addrbook.json > $HOME/.cascadiad/config/addrbook.json
```
### Add seeds
```python
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@rpc.cascadia.max-node.xyz:55656\"|" $HOME/.cascadiad/config/config.toml
```
### Set minimum gas price
```python
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"7aCC\"|" $HOME/.cascadiad/config/app.toml
```
### Set pruning
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.cascadiad/config/app.toml
```
### Set custom ports
```python
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:55658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:55657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:55060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:55656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":55660\"%" $HOME/.cascadiad/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:55317\"%; s%^address = \":8080\"%address = \":55080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:55090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:55091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:55545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:55546\"%" $HOME/.cascadiad/config/app.toml
```
### Download latest chain snapshot
```python
curl -L https://snapshots.max-node.xyz/cascadia/cascadia_6102-1_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.cascadiad
[[ -f $HOME/.cascadiad/data/upgrade-info.json ]] && cp $HOME/.cascadiad/data/upgrade-info.json $HOME/.cascadiad/cosmovisor/genesis/upgrade-info.json
```
### Start service and check the logs
```python
sudo systemctl start cascadiad && sudo journalctl -u cascadiad -f --no-hostname -o cat
```
