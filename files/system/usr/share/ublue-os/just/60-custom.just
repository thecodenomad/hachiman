# Ref: https://just.systems/man/en/

####################
# Utility Commands #
####################

# Unstick podman when socket file goes away
refresh-podman-socket:
    systemctl --user stop podman.socket
    systemctl --user disable podman.socket
    systemctl --user enable podman.socket
    systemctl --user start podman.socket
    systemctl --user status podman.socket

# Build Installer ISO for Hachiman based on upstream
generate-iso:
    mkdir -p $HOME/iso-output
    sudo podman run --rm --privileged --volume $HOME/iso-output:/build-container-installer/build --security-opt label=disable --pull=newer \
        ghcr.io/jasonn3/build-container-installer:latest \
        VERSION=40 \
        IMAGE_REPO=ghcr.io/thecodenomad \
        IMAGE_NAME=hachiman \
        IMAGE_TAG=40 \
        VARIANT=Server

# Nautilus plugin to add right-click menu for calculating shaXsums
# Ref: https://github.com/GeopJr/Collision/tree/main
nautilus-collision:
    mkdir -p ~/.local/share/nautilus-python/extensions/
    wget https://raw.githubusercontent.com/GeopJr/Collision/v3.8.1/nautilus-extension/collision-extension.py -O \
      ~/.local/share/nautilus-python/extensions/collision-extension.py

# Helper to upgrade the system
upgrade-hachiman:
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/thecodenomad/hachiman:latest


# Helpers to verify ssh fingerprints

ed25519-ssh-key:
    ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub

ecdsa-ssh-key:
    ssh-keygen -lf /etc/ssh/ssh_host_ecdsa_key.pub

rsa-ssh-key:
    ssh-keygen -lf /etc/ssh/ssh_host_rsa_key.pub


#####################
# Distrobox Tooling #
#####################

# Spin up all Hachiman Distroboxes
establish-distrobox:
    # Create folders for the distroboxes
    @echo "Creating local distroboxes home folders"
    mkdir -p "${HACHIMAN_DISTROBOX_HOME}/dev-home" \
             "${HACHIMAN_DISTROBOX_HOME}/perf-home"
    @echo "Creating local distroboxes"
    # Bug? using global creation caused issue with init hooks
    distrobox assemble create --name dev --file ${HACHIMAN_DISTROBOX_INI} --replace
    distrobox assemble create --name perf --file ${HACHIMAN_DISTROBOX_INI} --replace

# Utility for backing up Signal Desktop
# Ref: https://github.com/tbvdm/sigtop
sigtop:
    mkdir -p "${HACHIMAN_DISTROBOX_HOME}/sigtop-home"
    distrobox assemble create --file ${HACHIMAN_DISTROBOX_INI} --name sigtop --replace


install_optimized_zed:
    RUSTFLAGS='-C target-cpu=native' cargo build


################
# Applications #
################
# NOTE: The whole intent is to keep these applications restricted into their own home space
#       to avoid muddying the main local configs. These will gradually move as they are vetted
#       in workflows

protonmail:
    mkdir -p "${HACHIMAN_DISTROBOX_HOME}/proton-mail-home"
    distrobox assemble create --file ${HACHIMAN_DISTROBOX_INI} --name thorium-box --replace

thorium:
    mkdir -p "${HACHIMAN_DISTROBOX_HOME}/thorium-home"
    distrobox assemble create --file ${HACHIMAN_DISTROBOX_INI} --name proton-mail --replace


##########################
# Development Workspaces #
##########################
dev_workspaces:
    create_workspaces.sh dev
