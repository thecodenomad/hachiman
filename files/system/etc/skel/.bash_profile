# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

######################################################
# Hashiman specific environment and startup programs #
######################################################

# This sets the default location of the shared distrobox.ini file.
export HACHIMAN_DISTROBOX_INI="/usr/share/hachiman/distrobox/distrobox.ini"

# This sets the default location of the distrobox home folders
export HACHIMAN_DISTROBOX_HOME="${HOME}/.local/share/distrobox"

# Hachiman uses podman so make sure DOCKER_HOST is set the the users .sock file
export DOCKER_HOST=unix://$(podman info --format '{{.Host.RemoteSocket.Path}}')
