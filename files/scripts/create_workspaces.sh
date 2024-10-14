#!/usr/bin/env bash

##################################################################
#                                                                #
# Simple script to parse json file of workspaces. A workspace is #
# defined as a set of repos that should be cloned to a specific  #
# folder location.                                               #
#                                                                #
##################################################################

set -oue pipefail

# TODO: Support yaml
DEFAULT_CONFIG_PATH="${HOME}/.local/hachiman/workspaces.json"

# Allow override if the user chooses
eval WORKSPACE_CONFIG="${WORKSPACE_CONFIG:-"${DEFAULT_CONFIG_PATH}"}"

# User didn't provide a workspace
if [[ $# -eq 0 ]]; then
    echo "Please provide a workspace!"
    exit 1
fi

WORKSPACE="${1}"

check_and_clone() {
    repo=${1}
    base_folder=${2}
    repo_name=$(basename ${repo} | sed s/.git//g )
    repo_path="${base_folder}/${repo_name}"

    echo "Checking state of repo ${repo}..."

    # Check base folder path
    if [[ ! -e "${base_folder}" ]]; then
        echo "  Base Folder path '${base_folder}' doesn't exist"
        read -p "  Create path? (Y/n) : " response

        response=${response,,} # tolower
        if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
            mkdir -p ${base_folder}
        else
            echo "  Base folder doesn't exist, skipping cloning repo ${repo}"
            return
        fi
    fi

    # Check full repo path
    if [[ -e "${repo_path}" ]]; then
      echo "  Path ${repo_path} already exists, skipping..."
      return
    fi

    pushd "${base_folder}" > /dev/null
        echo "  Entering ${base_folder}"
        git clone "git@${repo}"
    popd > /dev/null
}

# Config check
if [[ ! -e "${WORKSPACE_CONFIG}" ]]; then
    echo "Workspace config not found at ${WORKSPACE_CONFIG}"
    exit 1
fi

# Workspace check
if ! jq -e ".workspaces[env.WORKSPACE]" ${WORKSPACE_CONFIG} > /dev/null; then
  echo "Workspace ${WORKSPACE} doesn't exist in ${WORKSPACE_CONFIG}"
  exit 1
fi

# Collect the repos to create
REPOS=($(jq -r ".workspaces[env.WORKSPACE].[] | @base64" ${WORKSPACE_CONFIG}))

# Iterate through the repos in the workspace
for row in "${!REPOS[@]}"; do
  _jq(){
    echo "${REPOS[$row]}" | base64 --decode | jq -r ${1}
  }
  repo=$(_jq '.repo')
  eval base_folder=$(_jq '.base_folder')
  check_and_clone ${repo} ${base_folder}
done
