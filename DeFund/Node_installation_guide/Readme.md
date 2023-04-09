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
rm -rf defund
git clone https://github.com/defund-labs/defund.git
cd defund
git checkout v0.2.6
# Build binaries
make build
```
### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.defund/cosmovisor/genesis/bin
mv build/defundd $HOME/.defund/cosmovisor/genesis/bin/
rm -rf build
``` 
### Create application symlinks
```python
ln -s $HOME/.defund/cosmovisor/genesis $HOME/.defund/cosmovisor/current
sudo ln -s $HOME/.defund/cosmovisor/current/bin/defundd /usr/local/bin/defundd
```
# Install Cosmovisor and create a service
### Download and install Cosmovisor
```python
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```
### Create service
```python
sudo tee /etc/systemd/system/defundd.service > /dev/null << EOF
[Unit]
Description=defund-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.defund"
Environment="DAEMON_NAME=defundd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.defund/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable defundd
```
# Initialize the node
### Set node configuration
```python
defundd config chain-id orbit-alpha-1
defundd config keyring-backend test
defundd config node tcp://localhost:40657
```
### Initialize the node
```python
defundd init $MONIKER --chain-id orbit-alpha-1
```
### Download genesis and addrbook
```pythom
curl -Ls https://snapshot.max-node.xyz/defund/genesis.json > $HOME/.defund/config/genesis.json
curl -Ls https://snapshot.max-node.xyz/defund/addrbook.json > $HOME/.defund/config/addrbook.json
```
### Add seeds
```python
sed -i -e "s|^seeds *=.*|seeds = \"6937d73ed186b7b7a89ecf6256d8023ba88c146f@rpc.defund.max-node.xyz:40656\"|" $HOME/.defund/config/config.toml
```
### Set minimum gas price
```python
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0ufetf\"|" $HOME/.defund/config/app.toml
```
### Set pruning
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.defund/config/app.toml
```
### Set custom ports
```python
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:40658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:40657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:40060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:40656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":40660\"%" $HOME/.defund/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:40317\"%; s%^address = \":8080\"%address = \":40080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:40090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:40091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:40545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:40546\"%" $HOME/.defund/config/app.toml
```
### Download latest chain snapshot
```python
curl -L https://snapshot.max-node.xyz/defund/_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.defund
[[ -f $HOME/.defund/data/upgrade-info.json ]] && cp $HOME/.defund/data/upgrade-info.json $HOME/.defund/cosmovisor/genesis/upgrade-info.json
```
### Start service and check the logs
```python
sudo systemctl start defundd && sudo journalctl -u defundd -f --no-hostname -o cat
```

