# Download and build upgrade binaries
### Clone project repository
```python
cd $HOME
rm -rf nolus-core
git clone https://github.com/Nolus-Protocol/nolus-core.git
cd nolus-core
git checkout v0.2.2-store-fix

### Build binaries
make build
```

### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.nolus/cosmovisor/upgrades/v0.2.2-store-fix/bin
mv target/release/nolusd $HOME/.nolus/cosmovisor/upgrades/v0.2.2-store-fix/bin/
rm -rf build
```
Thats it! Now when upgrade block height is reached, Cosmovisor will handle it automatically!
