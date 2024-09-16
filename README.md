# my-distroboxes

This repo reflects my personal approach/setup for [distrobox](https://github.com/89luca89/distrobox) & [podman](https://github.com/containers/podman).  
All images stem from the same base (`Containerfile.base`) which initializes
* the distribution [toolbx/arch-toolbox:latest](https://quay.io/repository/toolbx/arch-toolbox)
* Base packages

## Usage

### Build the image

It is recommended to first build the base image and the subsequently build all other child images.

```bash
podman build -t $IMAGE_NAME -f Containerfile
```

### Create the container from built image

```bash
distrobox create --name $CONTAINER_NAME --image localhost/$IMAGE_NAME --home ~/Distrobox/$CONTAINER_NAME --volume $SSH_AUTH_SOCK:$SSH_AUTH_SOCK:Z --additional-flags "--env SSH_AUTH_SOCK:{$SSH_AUTH_SOCK}"
```

### Finish the setup

```bash
distrobox enter $CONTAINER_NAME
```

To complete the setup you have to run the `init.sh` script from inside of the container and afterwards you have to exit and enter it again. The script will fetch dotfiles from GitHub using [chezmoi](https://www.chezmoi.io/) and may need SSH keys to access the repository - see [this](sharing-the-host-ssh-agent) how this is simplified here.

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