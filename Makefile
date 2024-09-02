clean:
	rm -rf ${PWD}/iso-output

iso: clean
	mkdir -p ${PWD}/iso-output
	sudo podman run --rm --privileged \
		--volume ${PWD}/iso-output:/build-container-installer/build \
		--security-opt label=disable \
		--pull=newer ghcr.io/jasonn3/build-container-installer:latest \
		IMAGE_REPO=ghcr.io/thecodenomad \
		IMAGE_NAME=hachiman \
		IMAGE_TAG=latest \
		VARIANT=Server \
		VERSION=40
