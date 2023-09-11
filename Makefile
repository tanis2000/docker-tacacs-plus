VERSION?=20230911
SHA256?=d2f2dbc7332934e87ae0c108ac9ec284616d57ebf06d49c01f4e8012bc0c195d
DOCKER_HUB_NAME?='tanis2000/tac_plus'
DOCKER_HUB_USERNAME?=tanis2000
DOCKER_HUB_PASSWORD?=password

.PHONY: alpine ubuntu tag

all: create-builder alpine ubuntu

ci: login create-builder alpine ubuntu

login:
	docker login --username $(DOCKER_HUB_USERNAME) --password $(DOCKER_HUB_PASSWORD)
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
