# Manual installation
### Setup validator name
```python
NODE_MONIKER="YOUR_MONIKER_GOES_HERE"
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
cd || return
rm -rf empowerchain
git clone https://github.com/EmpowerPlastic/empowerchain
cd empowerchain/chain || return
git checkout v1.0.0-rc2
### Build binaries
make build
empowerd version # 1.0.0-rc2
```
### Initialize the node
```python
empowerd config keyring-backend test
empowerd config chain-id circulus-1
empowerd init "$NODE_MONIKER" --chain-id circulus-1
``` 
### Download genesis and addrbook
```pythom
curl -s https://snapshots.max-node.xyz/empower/genesis.json > $HOME/.empowerchain/config/genesis.json
curl -s https://snapshots.max-node.xyz/empower/addrbook.json > $HOME/.empowerchain/config/addrbook.json
```
### Add seeds
```python
SEEDS="258f523c96efde50d5fe0a9faeea8a3e83be22ca@seed.circulus-1.empower.aviaone.com:20272,d6a7cd9fa2bafc0087cb606de1d6d71216695c25@51.159.161.174:26656,babc3f3f7804933265ec9c40ad94f4da8e9e0017@testnet-seed.rhinostake.com:17456"
PEERS=""
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.empowerchain/config/config.toml
```
### Set minimum gas price
```python
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.001umpwr"|g' $HOME/.empowerchain/config/app.toml
```
### Set pruning
```python
sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.empowerchain/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.empowerchain/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "10"|g' $HOME/.empowerchain/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 0|g' $HOME/.empowerchain/config/app.toml
```
### Create service
```python
sudo tee /etc/systemd/system/empowerd.service > /dev/null << EOF
[Unit]
Description=Empower Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which empowerd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
```

```python
empowerd tendermint unsafe-reset-all --home $HOME/.empowerchain --keep-addr-book
```

### Set custom ports
```python
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:30658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:30657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6460\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:30656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":30660\"%" $HOME/.empowerchain/config/config.toml && sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9490\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9491\"%; s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:1717\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:8945\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:8946\"%; s%^address = \"127.0.0.1:8545\"%address = \"127.0.0.1:8945\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"127.0.0.1:8946\"%" $HOME/.empowerchain/config/app.toml && sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:30657\"%" $HOME/.empowerchain/config/client.toml 
```

### Download latest chain snapshot
```python
SNAP_NAME=$(curl -s https://snapshots.max-node.xyz/empower/info.json | jq -r .fileName)
curl -L https://snapshots.max-node.xyz/empower/_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.empowerchain
```
### Start service and check the logs
```python
sudo systemctl daemon-reload
sudo systemctl enable empowerd
sudo systemctl start empowerd

sudo journalctl -u empowerd -f --no-hostname -o cat
```
