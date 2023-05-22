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
rm -rf archway
git clone https://github.com/archway-network/archway.git
cd archway
git checkout v0.5.2
### Build binaries
make build
```
### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.archway/cosmovisor/genesis/bin
mv build/archwayd $HOME/.archway/cosmovisor/genesis/bin/
rm -rf build
``` 
### Create application symlinks
```python
sudo ln -s $HOME/.archway/cosmovisor/genesis $HOME/.archway/cosmovisor/current -f
sudo ln -s $HOME/.archway/cosmovisor/current/bin/archwayd /usr/local/bin/archwayd -f
```
# Install Cosmovisor and create a service
### Download and install Cosmovisor
```python
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```
### Create service
```python
sudo tee /etc/systemd/system/archwayd.service > /dev/null << EOF
[Unit]
Description=archway-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.archway"
Environment="DAEMON_NAME=archwayd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.archway/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable archwayd
```
# Initialize the node
### Set node configuration
```python
archwayd config chain-id constantine-3
archwayd config keyring-backend test
archwayd config node tcp://localhost:15657
```
### Initialize the node
```python
archwayd init $MONIKER --chain-id constantine-3
```
### Download genesis and addrbook
```pythom
curl -Ls https://snapshots.kjnodes.com/archway-testnet/genesis.json > $HOME/.archway/config/genesis.json
curl -Ls https://snapshots.kjnodes.com/archway-testnet/addrbook.json > $HOME/.archway/config/addrbook.json
```
### Add seeds
```python
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@rpc.archway.max-node.xyz:15659\"|" $HOME/.archway/config/config.toml
```
### Set minimum gas price
```python
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0uconst\"|" $HOME/.archway/config/app.toml
```
### Set pruning
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.archway/config/app.toml
```
### Set custom ports
```python
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:15658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:15657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:15660\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:15656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":15666\"%" $HOME/.archway/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:15617\"%; s%^address = \":8080\"%address = \":15680\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:15690\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:15691\"%; s%:8545%:15645%; s%:8546%:15646%; s%:6065%:15665%" $HOME/.archway/config/app.toml
```
### Download latest chain snapshot
```python
curl -L https://snapshots.max-node.xyz/archway/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.archway
[[ -f $HOME/.archway/data/upgrade-info.json ]] && cp $HOME/.archway/data/upgrade-info.json $HOME/.archway/cosmovisor/genesis/upgrade-info.json
```
### Start service and check the logs
```python
sudo systemctl start archwayd && sudo journalctl -u archwayd -f --no-hostname -o cat```
