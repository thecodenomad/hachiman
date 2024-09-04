#! /usr/bin/env sh

# This sets the default location of the shared distrobox.ini file.
export HACHIMAN_DISTROBOX_INI="/usr/share/hachiman/distrobox/distrobox.ini"

# This sets the default location of the distrobox home folders
export HACHIMAN_DISTROBOX_HOME="${HOME}/.local/share/distrobox"

# Hachiman uses podman so make sure DOCKER_HOST is set the the users .sock file
export DOCKER_HOST=$(podman info --format '{{.Host.RemoteSocket.Path}}')
