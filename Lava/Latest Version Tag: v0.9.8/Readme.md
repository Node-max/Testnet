# Download and build upgrade binaries
### Clone project repository
```python
# Clone project repository
cd $HOME
rm -rf lava
git clone https://github.com/lavanet/lava.git
cd lava
git checkout v0.11.2

# Build binaries
make build
```

### Prepare binaries for Cosmovisor
```python
mkdir -p $HOME/.lava/cosmovisor/upgrades/v0.11.2/bin
mv build/lavad $HOME/.lava/cosmovisor/upgrades/v0.9.8/bin/
rm -rf build
```
**Thats it! Now when upgrade block height is reached, Cosmovisor will handle it automatically!**
