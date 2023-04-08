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
rm -rf andromedad
git clone https://github.com/andromedaprotocol/andromedad.git
cd andromedad
git checkout galileo-3-v1.1.0-beta1
### Build binaries
make build
```
### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.andromedad/cosmovisor/genesis/bin
mv build/andromedad $HOME/.andromedad/cosmovisor/genesis/bin/
rm -rf build
``` 
### Create application symlinks
```python
ln -s $HOME/.andromedad/cosmovisor/genesis $HOME/.andromedad/cosmovisor/current
sudo ln -s $HOME/.andromedad/cosmovisor/current/bin/andromedad /usr/local/bin/andromedad
```
# Install Cosmovisor and create a service
### Download and install Cosmovisor
```python
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```
### Create service
```python
sudo tee /etc/systemd/system/andromedad.service > /dev/null << EOF
[Unit]
Description=andromeda-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.andromedad"
Environment="DAEMON_NAME=andromedad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.andromedad/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable andromedad
```
# Initialize the node
### Set node configuration
```python
andromedad config chain-id galileo-3
andromedad config keyring-backend test
andromedad config node tcp://localhost:47657
```
### Initialize the node
```python
andromedad init $MONIKER --chain-id galileo-3
```
### Download genesis and addrbook
```pythom
curl -Ls https://snapshots.max-node.xyz/andromeda/genesis.json
curl -Ls https://snapshots.max-node.xyz/andromeda/addrbook.json
```
### Add seeds
```python
sed -i -e "s|^seeds *=.*|seeds = \"fec2ab9726f87d68d4f37f8c66cb852a2f6ce0c2@rpc.andromeda.max-node.xyz:47656\"|" $HOME/.andromeda/config/config.toml
```
### Set minimum gas price
```python
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0001uandr\"|" $HOME/.andromedad/config/app.toml
```
### Set pruning
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.andromedad/config/app.toml
```
### Set custom ports
```python
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:47658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:47657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:47060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:47656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":47660\"%" $HOME/.andromedad/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:47317\"%; s%^address = \":8080\"%address = \":47080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:47090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:47091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:47545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:47546\"%" $HOME/.andromedad/config/app.toml
```
### Download latest chain snapshot
```python
curl -L https://snapshots.max-node.xyz/andromeda/galileo-3_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.lava
mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json
```
### Start service and check the logs
```python
sudo systemctl start andromedad && sudo journalctl -u andromedad -f --no-hostname -o cat
```
