# Download and build upgrade binaries
### Clone project repository
```python
cd $HOME
rm -rf nolus-core
git clone https://github.com/Nolus-Protocol/nolus-core.git
cd nolus-core
git checkout v0.3.0

### Build binaries
make build
```

### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.nolus/cosmovisor/upgrades/v0.3.0/bin
mv target/release/nolusd $HOME/.nolus/cosmovisor/upgrades/v0.3.0/bin/
rm -rf build
```
Thats it! Now when upgrade block height is reached, Cosmovisor will handle it automatically!
