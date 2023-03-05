# Snapshot

- **install dependencies, if needed**
```pyton
sudo apt update
sudo apt install lz4 -y
```
# Snapshots are taken automatically every 6 hours

- **Stop Andromeda**
```pyton
sudo systemctl stop andromedad
```
- **Download latest snapshot**
```pyton
cp $HOME/.andromedad/data/priv_validator_state.json $HOME/.andromedad/priv_validator_state.json.backup
curl https://snapshot.andromeda.max-node.xyz/andromeda/andromeda-snapshot-20230303.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.andromedad
```
```pyton
mv $HOME/.andromedad/priv_validator_state.json.backup $HOME/.andromedad/data/priv_validator_state.json 
```

- **Restart the service and check the log**
```pyton
sudo systemctl start andromedad
sudo journalctl -u andromedad -f --no-hostname -o cat
```
