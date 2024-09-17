#!/bin/bash

GITHUB_USERNAME="DrStrangeloovee"

echo "Executing initial post container creation setup:"

# Install oh-my-zsh and change shell
#echo "Installing oh-my-zsh, themes & plugins..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Chezmoi init --apply
echo "Fetching dotfiles..."
chezmoi init --apply git@github.com:$GITHUB_USERNAME/dotfiles.git

echo "To finish the setup you have to re-enter the container!"

# Finish setup by switching users shell to zsh
sudo -k chsh -s /usr/bin/zsh "$USER"