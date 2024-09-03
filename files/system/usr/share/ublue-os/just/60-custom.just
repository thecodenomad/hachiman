establish-distrobox:
    @echo "Creating local distroboxes"
    distrobox assemble create --file /usr/share/hachiman/distrobox/distrobox.ini

generate-iso:
    mkdir -p $HOME/iso-output
    sudo podman run --rm --privileged --volume $HOME/iso-output:/build-container-installer/build --security-opt label=disable --pull=newer \
        ghcr.io/jasonn3/build-container-installer:latest \
        VERSION=40 \
        IMAGE_REPO=ghcr.io/thecodenomad \
        IMAGE_NAME=hachiman \
        IMAGE_TAG=40 \
        VARIANT=Server

# Ref: https://github.com/GeopJr/Collision/tree/main
nautilus-collision:
    mkdir -p ~/.local/share/nautilus-python/extensions/
    wget https://raw.githubusercontent.com/GeopJr/Collision/v3.8.1/nautilus-extension/collision-extension.py -O \
      ~/.local/share/nautilus-python/extensions/collision-extension.py
    nautilus -q || true


# Ref: https://github.com/tbvdm/sigtop
sigtop:
    distrobox assemble create --file ${GLOBAL_DISTROBOX_INI} --name sigtop --replace
