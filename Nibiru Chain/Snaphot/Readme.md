## Snapshots are taken automatically each day at 21:00 UTC
- **install dependencies, if needed**
```pyton
sudo apt update
sudo apt install lz4 -y
```
- **Stop nolus**

```pyton
sudo systemctl stop nibid
```
```pyton
cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup 
```
- **Download latest snapshot**
```pyton
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book 
curl https://snapshot.max-node.xyz/nibiru/snapshot.tar.lz4  | lz4 -dc - | tar -xf - -C $HOME/.nolus
```
```pyton
mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json 
```
- **Restart the service and check the log**
```pyton
sudo systemctl restart nibid
journalctl -u nibid  -f --no-hostname -o cat
```
