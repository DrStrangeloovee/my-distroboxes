# my-distroboxes

This repo reflects my personal approach/setup for [distrobox](https://github.com/89luca89/distrobox) & [podman](https://github.com/containers/podman) and tries to automate this process as much as possible.  
All images stem from the same base (`Containerfile.base`) which initializes
* the distribution [toolbx/arch-toolbox:latest](https://quay.io/repository/toolbx/arch-toolbox)
* Base packages

## Prerequisites:
* To keep the home directories of each container separated from the hosts home I prefer to set a directory for it. This can be easily done by setting the `DBX_CONTAINER_HOME_PREFIX` (this is done automatically when running the `create.sh` script) environment variable.
* Access to a git repository/needed ssh keys ([see](sharing-the-host-ssh-agent)) has to be provided before running the container specific init scripts. Otherwise some settings/environment variables are missing - this can be fixed by re-running the init script with access to the repository.

## Usage

Most of the process is automated by executing the `./build.sh` which builds all the images and then creates the defined containers according to the `distrobox.ini`.

The following steps describe the steps which you could go trhough manually.

### Build the image

It is recommended to first build the base image and the subsequently build all other child images.

```bash
podman build -t $IMAGE_NAME -f Containerfile
```

### Create the container from an image

This will create the specified image with the defined path for the home directory and the hosts ssh authentication agent is passed into the container.

```bash
distrobox create --name $CONTAINER_NAME --image localhost/$IMAGE_NAME --home ~/Distrobox/$CONTAINER_NAME --volume $SSH_AUTH_SOCK:$SSH_AUTH_SOCK:Z --additional-flags "--env SSH_AUTH_SOCK:{$SSH_AUTH_SOCK}" --volume ~/Dev::rw
```

### Finish the setup

```bash
distrobox enter $CONTAINER_NAME
```

To complete the setup you have to run the `init.sh` script from inside of the container and afterwards you have to exit and enter it again.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/DrStrangeloovee/my-distroboxes/master/init.sh)"
```

## A note on linking programs

I find it useful to be able to be able to use podman from the host system - wheter or not you need that is up to you and differs from each use case. Feel free to change this as needed.  
What you will often see is something like the following:

```Dockerfile
RUN  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
     ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
     ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
     ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
     ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
```

Consult the distrobox [documentation](https://distrobox.it/posts/execute_commands_on_host/) for more info.

## Sharing the host ssh agent

To simplify ssh access the hosts ssh-agent is passed into the container by
1. Mounting the socket into it.
2. Setting the $SSH_AUTH_SOCKET variable.
at the creation of the container. This gives you the benefit of storing your keys on the host and make them available to all containers at once - even works through KeePass with its ssh-agent integration.

```bash
distrobox create --name $CONTAINER_NAME --image localhost/$IMAGE_NAME --home ~/Distrobox/$CONTAINER_NAME --volume $SSH_AUTH_SOCK:$SSH_AUTH_SOCK:Z --additional-flags "--env SSH_AUTH_SOCK:{$SSH_AUTH_SOCK}"
```

Note:
Check that the container user (the one distrobox creates for you) shares the same UID - otherwise you will almost certainly run into issues. (TODO: document/find solution for this)

# Open improvements

The following is a list of open improvements which further automate the setup:

1. If the user enters the container the first time he should get a message that the container can be setup by running the `init.sh` or it could be baked in the container image.
2. Add chezmoi [machine specific](https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/) dotfiles
3. Setup gitconfig (via chezmoi?)
4. For fh-b3-ai the rye shim ([mkdir $ZSH_CUSTOM/plugins/rye
rye self completion -s zsh > $ZSH_CUSTOM/plugins/rye/_rye](https://rye.astral.sh/guide/installation/#shell-completion)) can't be set because the $ZSH_CUSTOM variable is not available - this has to be run under an active zsh session.
5. Setup zsh completions
    4.1. [ripgrep](https://github.com/BurntSushi/ripgrep/blob/master/FAQ.md#complete)
6. Automate VSCode plugin install/setup
