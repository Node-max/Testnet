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
rm -rf babylon
git clone https://github.com/babylonchain/babylon
cd babylon
git checkout v0.5.0
# Build binaries
make build
babylond version # v0.5.0
```
### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.babylond/cosmovisor/genesis/bin
mv build/babylond $HOME/.babylond/cosmovisor/genesis/bin/
rm -rf build
``` 
### Create application symlinks
```python
ln -s $HOME/.babylond/cosmovisor/genesis $HOME/.babylond/cosmovisor/current
sudo ln -s $HOME/.babylond/cosmovisor/current/bin/gitopiad /usr/local/bin/babylon
```
# Install Cosmovisor and create a service
### Download and install Cosmovisor
```python
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```
### Create service
```python
sudo tee /etc/systemd/system/babylond.service > /dev/null << EOF
[Unit]
Description=Babylon Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which babylond) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

babylond tendermint unsafe-reset-all --home $HOME/.babylond --keep-addr-book

sudo systemctl daemon-reload
sudo systemctl enable babylond
```
# Initialize the node
### Set node configuration
```python
babylond config chain-id bbn-test1
babylond config keyring-backend test
babylond config node tcp://localhost:51657
```
### Initialize the node
```python
babylond init $MONIKER --chain-id bbn-test1
```
### Download genesis and addrbook
```pythom
curl -Ls https://snapshots.max-node.xyz/babylon/genesis.json > $HOME/.babylond/config/genesis.json
curl -Ls https://snapshots.max-node.xyz/babylon/addrbook.json > $HOME/.babylond/config/addrbook.json
```
### Add seeds
```python
sed -i -e "s|^seeds *=.*|seeds = \"3d8c866fc1d5f35a472d4ffdb4e6304df985de9e@rpc.babylon.max-node.xyz:50659\"|" $HOME/.babylond/config/config.toml
```
### Set minimum gas price
```python
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025ubbn\"|" $HOME/.babylond/config/app.toml
```
### Set pruning
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.babylond/config/app.toml
```
### Set custom ports
```python
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:51658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:51657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:51060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:51656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":51660\"%" $HOME/.babylond/config/config.tomlsed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:50317\"%; s%^address = \":8080\"%address = \":50080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:50090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:50091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:50545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:50546\"%" $HOME/.babylond/config/app.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:51317\"%; s%^address = \":8080\"%address = \":51080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:51090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:51091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:51545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:41546\"%" $HOME/.babylond/config/app.toml
```
### Download latest chain snapshot
```python
curl -L https://snapshots.max-node.xyz/babylon/bbn-test1_latest.tar.lz4  | tar -Ilz4 -xf - -C $HOME/.gitopia
[[ -f $HOME/.babylond/data/upgrade-info.json ]] && cp $HOME/.babylond/data/upgrade-info.json $HOME/.babylond/cosmovisor/genesis/upgrade-info.json
```
### Start service and check the logs
```python
sudo systemctl start babylond && sudo journalctl -u babylond -f --no-hostname -o cat
```
