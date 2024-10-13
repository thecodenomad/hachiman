#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# This shell script is used to create dev workspaces.
# A workspace is simply a folder structure where git repos are stored.

# DEFAULT_WORKSPACE_CONFIG is a yaml file that should be captured by
# dotfile configuration management (chezmoi, stow, etc)
DEFAULT_WORKSPACE_CONFIG=$HOME/.local/hachiman/workspaces.yml

WORKSPACE=$0

# Does the workspace exist
if ! yq '.workspace | strenv(WORKSPACE)' $HOME/.local/hachiman/workspaces.yml; then
  echo "Workspace ${WORKSPACE} doesn't exist in ${DEFAULT_WORKSPACE_CONFIG}"
  exit 1
fi

REPO=$(yq '.workspaces[] | select(strenv(WORKSPACE)) | .repo' $DEFAULT_WORKSPACE_CONFIG)
eval BASE_FOLDER=$(yq '.workspaces[] | select(strenv(WORKSPACE)) | .base_folder' $DEFAULT_WORKSPACE_CONFIG)

# Does the repo already exist?
REPO_NAME=$(basename ${REPO} | sed s/.git//)
if [[ -e "${BASE_FOLDER}/${REPO_NAME}" ]]; then
  echo "Repo '${REPO_NAME}' already exists in '${BASE_FOLDER}', skipping..."
  exit 1
fi

pushd "${BASE_FOLDER}" > /dev/null
    echo "Entering ${BASE_FOLDER}"
    git clone "git@${REPO}"
popd > /dev/null
