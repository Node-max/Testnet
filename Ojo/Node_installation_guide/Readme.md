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
rm -rf ojo
git clone https://github.com/ojo-network/ojo.git
cd ojo
git checkout v0.1.2
# Build binaries
make build
```
### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.ojo/cosmovisor/genesis/bin
mv build/ojod $HOME/.ojo/cosmovisor/genesis/bin/
rm -rf build
``` 
### Create application symlinks
```python
ln -s $HOME/.ojo/cosmovisor/genesis $HOME/.ojo/cosmovisor/current
sudo ln -s $HOME/.ojo/cosmovisor/current/bin/ojod /usr/local/bin/ojod
```
# Install Cosmovisor and create a service
### Download and install Cosmovisor
```python
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```
### Create service
```python
sudo tee /etc/systemd/system/ojod.service > /dev/null << EOF
[Unit]
Description=ojo-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.ojo"
Environment="DAEMON_NAME=ojod"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.ojo/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable ojod
```
# Initialize the node
### Set node configuration
```python
ojod config chain-id ojo-devnet
ojod config keyring-backend test
ojod config node tcp://localhost:50657
```
### Initialize the node
```python
ojod init $MONIKER --chain-id ojo-devnet
```
### Download genesis and addrbook
```pythom
curl -Ls https://snapshots.max-node.xyz/ojo/genesis.json > $HOME/.ojo/config/genesis.json
curl -Ls https://snapshots.max-node.xyz/ojo/addrbook.json > $HOME/.ojo/config/addrbook.json
```
### Add seeds
```python
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@ojo-testnet.rpc.kjnodes.com:50659\"|" $HOME/.ojo/config/config.toml
```
### Set minimum gas price
```python
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0uojo\"|" $HOME/.ojo/config/app.toml
```
### Set pruning
```python
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.ojo/config/app.toml
```
### Set custom ports
```python
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:50658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:50657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:50060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:50656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":50660\"%" $HOME/.ojo/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:50317\"%; s%^address = \":8080\"%address = \":50080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:50090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:50091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:50545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:50546\"%" $HOME/.ojo/config/app.toml
```
### Download latest chain snapshot
```python
curl -L https://snapshots.max-node.xyz/ojo/ojo-devnet_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.ojo
[[ -f $HOME/.ojo/data/upgrade-info.json ]] && cp $HOME/.ojo/data/upgrade-info.json $HOME/.ojo/cosmovisor/genesis/upgrade-info.json
```
### Start service and check the logs
```python
sudo systemctl start ojod && sudo journalctl -u ojod -f --no-hostname -o cat
```

# Set up Price Feeder
## To run pricefeeder you validator should be in active set. Otherwise price feeder will not vote on periods.
### nstall the pricefeeder binary and create directory for pricefeeder configuration
```python
cd $HOME && rm price-feeder -rf
git clone https://github.com/ojo-network/price-feeder
cd price-feeder
git checkout v0.1.1
make build
sudo mv ./build/price-feeder /usr/local/bin
rm $HOME/.ojo-price-feeder -rf
mkdir $HOME/.ojo-price-feeder
mv price-feeder.example.toml $HOME/.ojo-price-feeder/config.toml
```
## Check price-feeder version
```python
price-feeder version
# version: HEAD-5d46ed438d33d7904c0d947ebc6a3dd48ce0de59
# commit: 5d46ed438d33d7904c0d947ebc6a3dd48ce0de59
```
### Create new wallet for pricefeeder and save 24 word mnemonic phrase
```python
ojod keys add pricefeeder-wallet --keyring-backend os
```
### Export keyring password
 ```python
 export KEYRING_PASSWORD="PRICE_FEEDER_KEY_PASSWORD_GOES_HERE"
```
### Set up variables
```python
export KEYRING="os"
export LISTEN_PORT=7172
export RPC_PORT=50657
export GRPC_PORT=50090
export VALIDATOR_ADDRESS=$(ojod keys show wallet --bech val -a)
export MAIN_WALLET_ADDRESS=$(ojod keys show wallet -a)
export PRICEFEEDER_ADDRESS=$(echo -e $KEYRING_PASSWORD | ojod keys show pricefeeder-wallet --keyring-backend os -a)
```
### Fund the pricefeeder-wallet with some testnet tokens.
### In order to make pricefeeder work, it needs some tokens to pay for transaction fees
### This command will send 1 OJO to pricefeeder-wallet from you main wallet
```python
ojod tx bank send wallet $PRICEFEEDER_ADDRESS 1000000uojo --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
### Check the balance
```python
ojod q bank balances $PRICEFEEDER_ADDRESS
```
### Delegate pricefeeder responsibility
### As a validator, if you'd like another account to post prices on your behalf (i.e. you don't want your validator mnemonic sending txs), you can delegate pricefeeder responsibilities to another address.
```python
ojod tx oracle delegate-feed-consent $MAIN_WALLET_ADDRESS $PRICEFEEDER_ADDRESS --from wallet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
### Check linked pricefeeder address
```python
ojod q oracle feeder-delegation $VALIDATOR_ADDRESS
```
### Set pricefeeder configuration values
```python
sed -i "s/^listen_addr *=.*/listen_addr = \"0.0.0.0:${LISTEN_PORT}\"/;\
s/^address *=.*/address = \"$PRICEFEEDER_ADDRESS\"/;\
s/^chain_id *=.*/chain_id = \"ojo-devnet\"/;\
s/^validator *=.*/validator = \"$VALIDATOR_ADDRESS\"/;\
s/^backend *=.*/backend = \"$KEYRING\"/;\
s|^dir *=.*|dir = \"$HOME/.ojo\"|;\
s|^grpc_endpoint *=.*|grpc_endpoint = \"localhost:${GRPC_PORT}\"|;\
s|^tmrpc_endpoint *=.*|tmrpc_endpoint = \"http://localhost:${RPC_PORT}\"|;\
s|^global-labels *=.*|global-labels = [[\"chain_id\", \"ojo-devnet\"]]|;\
s|^service-name *=.*|service-name = \"ojo-price-feeder\"|;" $HOME/.ojo-price-feeder/config.toml
```
### Setup the systemd service
```python
sudo tee /etc/systemd/system/ojo-price-feeder.service > /dev/null <<EOF
[Unit]
Description=Ojo Price Feeder
After=network-online.target

[Service]
User=$USER
ExecStart=$(which price-feeder) $HOME/.ojo-price-feeder/config.toml
Restart=on-failure
RestartSec=30
LimitNOFILE=65535
Environment="PRICE_FEEDER_PASS=$KEYRING_PASSWORD"

[Install]
WantedBy=multi-user.target
EOF
```
### Register and start the systemd service
```python
sudo systemctl daemon-reload
sudo systemctl enable ojo-price-feeder
sudo systemctl restart ojo-price-feeder
```
### View pricefeeder logs
```python
journalctl -fu ojo-price-feeder -o cat
```
### Successfull Log examples:
```python
10:30AM INF broadcasting vote exchange_rates=ATOM:11.449658317452328488,BNB:286.505174071110084991,CRO:0.069718618570227407,DAI:0.999872679370903845,ETH:1552.960176513619371601,IST:1.013970239583170325,OSMO:0.826831324620249729,UMEE:0.007902144939292575,USDC:0.999873169363824893,USDT:0.999851633546200939,WBTC:22001.354045277520185398,stATOM:12.378471944671440576,stOSMO:0.869546768297473244 feeder=ojo1akr5mgltsde7lke3cgxwf2pcug3rnyfy67dl6p module=oracle validator=ojovaloper1mfasrshu4k0wlksvgjyvahe7hz67sw4z0pst3f
10:30AM INF successfully broadcasted tx module=oracle_client tx_code=0 tx_hash=354B62AC58F370F6E866F019A7C14E93E456F6A1355AFE92B915DABCF4C89C86 tx_height=0
10:30AM INF broadcasting pre-vote feeder=ojo1akr5mgltsde7lke3cgxwf2pcug3rnyfy67dl6p hash=9fefb35d3499ce13339c37b65e5fa79b898c1d09 module=oracle validator=ojovaloper1mfasrshu4k0wlksvgjyvahe7hz67sw4z0pst3f
10:30AM INF successfully broadcasted tx module=oracle_client tx_code=0 tx_hash=8E918F16931972681A5CC8C1E0F3E082561D8899DD672D5FA6D943FC81E8179A tx_height=0
10:31AM INF skipping until next voting period current_vote_period=64750 module=oracle previous_vote_period=64750 vote_period=5
10:31AM INF skipping until next voting period current_vote_period=64750 module=oracle previous_vote_period=64750 vote_period=5
```
### Also you can check that your pricefeeder-wallet is doing transactions on chain at Chain Explorer
![image](https://user-images.githubusercontent.com/61777095/230781235-78e2f1b5-4018-4d9b-b828-c4f7e18c5d54.png)

## Useful commands
### Check current voting windows progress
```python
ojod q oracle slash-window
```
### Check missed oracle votes per slashing window
```python
ojod q oracle miss-counter $VALIDATOR_ADDRESS
```
