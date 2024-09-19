#!/bin/bash

/bin/bash ../init.sh

echo "Executing ${CONTAINER_ID} specific setup:"

echo "Installing rye..."
curl -sSf https://rye.astral.sh/get | bash
mkdir $ZSH_CUSTOM/plugins/rye
echo 'source "$HOME/.rye/env"' >> ~/.zshrc
rye self completion -s zsh > $ZSH_CUSTOM/plugins/rye/_rye
