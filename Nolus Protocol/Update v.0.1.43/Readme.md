- **Upgrading to version 0.1.43**
```python
cd
rm -rf nolus-core
git clone https://github.com/Nolus-Protocol/nolus-core.git 
cd nolus-core
git checkout v0.1.43 
make install 
```
- **Checking the version**
```python
nolusd version 
```

- **Restarting the node**
```python
sudo systemctl restart nolusd && sudo journalctl -u nolusd -f -o cat
```
