#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# This shell script is used to create dev workspaces.
# A workspace is simply a folder structure where git repos are stored.

# SYSTEM_WORKSPACE_CONFIG is a yaml file that is provided as a part of 
# the hachiman repo.
# SYSTEM_WORKSPACE_CONFIG

# DEFAULT_WORKSPACE_CONFIG is a yaml file that should be captured by
# dotfile configuration management (chezmoi, stow, etc)
DEFAULT_WORKSPACE_CONFIG=$HOME/.local/hachiman/workspaces.yml

