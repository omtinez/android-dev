.PHONY: all
IMAGE_NAME=omtinez/android-dev
all: usage

usage:
	@echo "Docker Build and Push"
	@echo "Usage:"
	@echo "  make build: Build the Docker image"
	@echo "  make run: Runs the Docker image"
	@echo "  make clean: Kills and deletes all instances of the Docker image"
	@echo "  make push: Push image to registry"
	@echo ""
	@echo "Change registry and image name in this Makefile before push."

build:
	docker build . -t $(IMAGE_NAME)

run:
	docker run -v "$(PWD):/root/workspace" -it $(IMAGE_NAME)

clean:
	docker rmi -f $(IMAGE_NAME) || true
	docker system prune -af

push: build
	docker push -t $(IMAGE_NAME)
