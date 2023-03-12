# Snapshot

- **install dependencies, if needed**
```pyton
sudo apt update
sudo apt install lz4 -y
```

- **Stop nolus**

```pyton
sudo systemctl stop nolusd
```
```pyton
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup 
```
- **Download latest snapshot**
```pyton
nolusd tendermint unsafe-reset-all --home $HOME/.nolus --keep-addr-book 
curl hhttps://snapshot-nolus.max-node.xyz/nolus/nolusd-snapshot-20230310.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nolus
```
```pyton
mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json 
```
- **Restart the service and check the log**
```pyton
systemctl restart nolusd && journalctl -u nolusd -f -o cat
```

