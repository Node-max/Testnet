# Download and build upgrade binaries
### Clone project repository
```python
cd $HOME
rm -rf lava
git clone https://github.com/lavanet/lava.git
cd lava
git checkout v0.8.1
# Build binaries
make build
```

### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.lava/cosmovisor/upgrades/v0.8.1/bin
mv build/lavad $HOME/.lava/cosmovisor/upgrades/v0.8.1/bin/
rm -rf build
```
**Thats it! Now when upgrade block height is reached, Cosmovisor will handle it automatically!**
