IMAGE=components
VERSION?=latest
.PHONY:  test clean

build:
	docker build --no-cache -t ${IMAGE}:${VERSION} .

run:
	npm run server:dev
