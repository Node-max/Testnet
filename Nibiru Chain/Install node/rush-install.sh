#!/bin/bash

sudo apt update && sudo apt install curl
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
rustc --version
