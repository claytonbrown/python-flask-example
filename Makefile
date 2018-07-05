# Example Makefile.
# Useful for providing shortcuts to container build / usage methods

NAME = panubo/python-flask-example
VERSION = `git describe --long --tags --dirty --always 2> /dev/null || echo "0.0.0"`

.PHONY: all build tag_latest clean

all:    clean build

build:
	docker build --no-cache -t $(NAME):$(VERSION) .

run:
	docker run --rm -t -i -P $(NAME):$(VERSION)

bash:
	docker run --rm -t -i -P $(NAME):$(VERSION) bash

clean:
	docker images | grep $(NAME) | awk '{ print $$3 }' | xargs -n 1 docker rmi
