FROM quay.io/toolbx/arch-toolbox:latest

COPY packages /

# Install common base packages
RUN grep -v '^#' /packages | \
    xargs pacman -Syyu --needed --noconfirm && \
    rm /packages

# Link commands back to the host
RUN  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman

# Create separate build user to handle installation from source
RUN  useradd -m --shell=/bin/bash build && usermod -L build && \
     echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
     echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER build
WORKDIR /home/build
COPY aur-packages /home/build

# Install & init yay
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    yay -Y --gendb && \
    grep -v '^#' /home/build/aur-packages | \
    xargs yay -S --noconfirm
