#!/usr/bin/env bash

# Generate the ISO
podman run --rm --privileged \
		--volume ${PWD}/iso-output:/build-container-installer/build \
		--security-opt label=disable \
		--pull=newer ghcr.io/jasonn3/build-container-installer:latest \
		IMAGE_REPO=${IMAGE_REPO} \
		IMAGE_NAME=hachiman \
		IMAGE_TAG=${IMAGE_TAG} \
		VARIANT=Server \
		VERSION=40
		
# Change the permissions
echo "Change owner of iso to current user.""
chown ${USER}:${USER} ${PWD}/iso-output/*