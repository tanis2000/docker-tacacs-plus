VERSION?=20250520
SHA256?=f340ad2ce307cba9694c820fa278d722d4ba6b47ded60dc4e654913f59013632
DOCKER_HUB_NAME?='tanis2000/tac_plus'

.PHONY: alpine ubuntu tag

all: create-builder alpine ubuntu

ci: create-builder ci-alpine ci-ubuntu

create-builder:
	docker buildx create --name multi-arch-builder --bootstrap --use

alpine:
	docker buildx build --platform linux/amd64,linux/arm64 \
		-t $(DOCKER_HUB_NAME):alpine -t $(DOCKER_HUB_NAME):alpine-$(VERSION) \
		--build-arg SRC_VERSION=$(VERSION) \
		--build-arg SRC_HASH=$(SHA256) \
		-f alpine.Dockerfile \
		--push .

ubuntu:
	docker buildx build --platform linux/amd64,linux/arm64 \
		-t $(DOCKER_HUB_NAME):latest -t $(DOCKER_HUB_NAME):ubuntu -t $(DOCKER_HUB_NAME):ubuntu-$(VERSION) \
		--build-arg SRC_VERSION=$(VERSION) \
		--build-arg SRC_HASH=$(SHA256) \
		-f Dockerfile \
		--push .

ci-alpine:
	docker build \
		-t $(DOCKER_HUB_NAME):alpine \
		--build-arg SRC_VERSION=$(VERSION) \
		--build-arg SRC_HASH=$(SHA256) \
		-f alpine.Dockerfile \
		.

ci-ubuntu:
	docker build \
		-t $(DOCKER_HUB_NAME):ubuntu \
		--build-arg SRC_VERSION=$(VERSION) \
		--build-arg SRC_HASH=$(SHA256) \
		-f Dockerfile \
		.