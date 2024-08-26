establish-distrobox:
    @echo "Creating local distroboxes"
    distrobox assemble create --file /usr/share/hachiman/distrobox/distrobox.ini

generate-iso:
    mkdir -p $HOME/iso-output
    sudo podman run --rm --privileged --volume $HOME/iso-output:/build-container-installer/build --security-opt label=disable --pull=newer \
        ghcr.io/jasonn3/build-container-installer:latest \
        # iso config:
        VERSION=40 \
        IMAGE_REPO=docker.io/library \
        IMAGE_NAME=hachiman \
        IMAGE_TAG=local-40 \
        VARIANT=Silverblue
