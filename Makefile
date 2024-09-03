# Default to Github Registry
IMAGE_REPO="ghcr.io/thecodenomad"
IMAGE_TAG="latest"

clean:
	rm -rf ${PWD}/iso-output

build: clean
	bluebuild generate -d ./recipes/recipe.yml
	bluebuild build ./recipes/recipe.yml

iso: build
	mkdir -p ${PWD}/iso-output
	sudo podman run --rm --privileged \
		--volume ${PWD}/iso-output:/build-container-installer/build \
		--security-opt label=disable \
		--pull=newer ghcr.io/jasonn3/build-container-installer:latest \
		IMAGE_REPO=${IMAGE_REPO} \
		IMAGE_NAME=hachiman \
		IMAGE_TAG=${IMAGE_TAG} \
		VARIANT=Server \
		VERSION=40

cosmic-build:
	bluebuild generate -d ./recipes/recipe-cosmic.yml
	bluebuild build ./recipes/recipe-cosmic.yml

cosmic-iso: clean #cosmic-build
	mkdir -p ${PWD}/iso-output
	sudo podman run --rm --privileged \
		--volume ${PWD}/iso-output:/build-container-installer/build \
		--security-opt label=disable \
		--pull=newer ghcr.io/jasonn3/build-container-installer:latest \
		IMAGE_REPO=${IMAGE_REPO} \
		IMAGE_NAME=cosmic-hachiman \
		IMAGE_TAG=${IMAGE_TAG} \
		VARIANT=Server \
		VERSION=40
