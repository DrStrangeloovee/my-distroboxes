#!/bin/bash

# Exit if outside of container

if [ -z ${CONTAINER_ID+x} ]; then
    echo "ERROR: This script is intended to be run inside of a container!"
    exit 1
fi

github_user="DrStrangeloovee"
repo_name="my-distroboxes"
repo_url="https://raw.githubusercontent.com/${github_user}/${repo_name}/master"

echo "Executing initial post container creation setup:"

# Install oh-my-zsh and change shell
#echo "Installing oh-my-zsh, themes & plugins..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Chezmoi init --apply
echo "Fetching dotfiles..."
chezmoi init --apply git@github.com:$github_user/dotfiles.git

# If needed run additional container specific setup
if [ $CONTAINER_ID != "base" ]; then

    script_url="${repo_url}/${CONTAINER_ID}/init.sh"
    echo "Fetching script from: ${script_url}"

    # Try to download the script
    if curl --silent --fail "$script_url" --output "init_$CONTAINER_ID.sh"; then
        echo "Script $script_name.sh downloaded successfully."

        # Set the script executable
        chmod +x "init_$CONTAINER_ID.sh"

        # Execute it
        echo "Executing the congtainer specific setup..."
        ./"init_$CONTAINER_ID.sh"

        # Remove it after execution
        rm ./"init_${CONTAINER_ID}.sh"
    else
        echo "Script not found at $script_url. Skipping execution."
    fi
fi

echo "To finish the setup you have to re-enter the container!"

# Finish setup by switching users shell to zsh
sudo -k chsh -s /usr/bin/zsh "$USER"