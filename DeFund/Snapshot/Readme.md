# Snapshop
## install dependencies, if needed
```python
sudo apt update
sudo apt install lz4 -y
```
## Stop the service and reset the data
```python
sudo systemctl stop defundd
cp $HOME/.defund/data/priv_validator_state.json $HOME/.defund/priv_validator_state.json.backup
rm -rf $HOME/.defund/data
```
## Download latest snapshot
```python
curl -L https://snapshot.max-node.xyz/defund/snapshot.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.defund
mv $HOME/.defund/priv_validator_state.json.backup $HOME/.defund/data/priv_validator_state.json
```
## Restart the service and check the log
```python
sudo systemctl start defundd && sudo journalctl -u defundd -f --no-hostname -o cat
```

# Live Peers
```python
PEERS="240f1a1e72438c967009bca40577ff3f1e75b74e@5.182.33.99:40656,60c436fe89d11b5a19100bea5097f1bc7ef40f66@95.216.14.58:60956,f9fcb1705d112b357fa498bb0711e2f4953d3f88@85.10.202.135:40656,2a0d9a217a96dbe7f5bc9fccff8b50da29f41f52@5.9.147.185:18656,18921a27facf3760d59147e4ae176b1bdf226346@195.201.237.172:18656,7c459f88962a4d07d7ccd6d0c94f891bb7a7ada0@65.109.26.21:13656,c0098c96773cbd0d7507d037768845c582f1a878@65.108.202.230:27656,91bbf1434b741862e406ab87c014fdff3cc96109@77.232.40.71:26656,8b80bc13d578d4e80fd672c247491f917c26a71d@84.201.162.168:26656,0484eab6881ba458c5988296403963aaf273700b@157.90.236.25:18656,7d988c0b027cb08ccda631c5c4eb65e2a543f393@144.76.164.139:13656,854cfaf6fd4de846fd020fbd7d0b5364c6fb9c58@65.21.95.46:27656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:40656,da7e109ceb4376c812267062fddf98f01ec834df@40.83.10.226:26656,a8bd3dbc18a1403c7899ba46f82fcc73f1db73ee@65.108.6.45:60556,a3ede88696b2b5f752129889b84b9292a168133a@142.132.152.46:21656,bfef03639bddf4fa503bb75c83af2b5f12c8276c@161.97.155.154:26656,74e6425e7ec76e6eaef92643b6181c42d5b8a3b8@65.108.231.124:18656,31b49e981e804cac50a092468e746e496740153e@65.109.84.254:26656,3209ec925afead6706ac250aae88d1b85a45a2d3@167.86.85.247:30656,d489680927b14fc0382f637156375a351f59295b@95.111.237.228:30656,5b3a2c084f0694b18fbfe560819cfbf3040ac24c@154.53.63.158:30656,e3c348467a8c88c0f65e2ca8a71875d2a384b8b4@185.16.39.19:60656,6f82e772ee8ae1895edc9743dbb269fb7c33f06a@144.91.89.158:30656,2dbf17b447b86f551460a9b131550e9c1aedabfe@89.22.231.244:26656,aa8fe9867b286094b53845a67791930325921c56@91.77.165.172:27767"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.defund/config/config.toml
```

