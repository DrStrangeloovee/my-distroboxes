#!/bin/bash

# Install & configure rye
echo "Setup rye..."
curl -sSf https://rye.astral.sh/get | zsh
mkdir $ZSH_CUSTOM/plugins/rye
echo 'source "$HOME/.rye/env"' >> ~/.zshrc # This will fail if shell wasn't changed to ZSH
rye self completion -s zsh > $ZSH_CUSTOM/plugins/rye/_rye
