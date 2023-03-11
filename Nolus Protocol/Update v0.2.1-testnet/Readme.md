- **Upgrading to v0.2.1-testnet**
```python
cd $HOME
rm -rf nolus-core
git clone https://github.com/Nolus-Protocol/nolus-core.git
cd nolus-core
git checkout v0.2.1-testnet
make build
```
```python
mkdir -p $HOME/.nolus/cosmovisor/upgrades/v0.2.1/bin
mv target/release/nolusd $HOME/.nolus/cosmovisor/upgrades/v0.2.1/bin/
rm -rf build
```
- **Checking the version**
```python
nolusd version 
```

## Non-Cosmovisor : 

UPGRADE AT BLOCK 1327000 !!!!

```python
cd $HOME
rm -rf nolus-core
git clone https://github.com/Nolus-Protocol/nolus-core.git
cd nolus-core
git checkout v0.2.1-testnet
make install
```

- **Restarting the node**
```python
sudo systemctl restart nolusd && sudo journalctl -u nolusd -f -o cat
```
