# Snapshot

- **install dependencies, if needed**
```pyton
sudo apt update
sudo apt install lz4 -y
```
- **Stop Quasar**
```pyton
sudo systemctl stop quasard
```
- **Download latest snapshot**
```pyton
cp $HOME/.quasarnode/data/priv_validator_state.json $HOME/.quasarnode/priv_validator_state.json.backup
curl https://snapshot.node-max.space/Quasar/Quasar-snapshot-20230314.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.quasarnode
```
```pyton
mv $HOME/.quasarnode/priv_validator_state.json.backup $HOME/.quasarnode/data/priv_validator_state.json 
```

- **Restart the service and check the log**
```pyton
sudo systemctl start quasard
sudo systemctl restart quasard  && sudo journalctl -u quasard -f -o cat
```
