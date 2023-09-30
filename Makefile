GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(dir $(MAKEFILE_PATH))
PROJECT_NAME = kube-cluster-jobs
DOCKER_IMAGE_COMMIT_SHA=$(shell git show -s --format=%h)
DOCKER_IMAGE_REPO = dodoreg.azurecr.io/${PROJECT_NAME}
SHELL := /bin/bash

BUILD_OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
BUILD_ARCH := $(shell uname -m | tr '[:upper:]' '[:lower:]')
JOB = ""

.PHONY: all
all: help

.PHONY: dc
dc:
	docker-compose up  --remove-orphans --build

.PHONY: run
run:
	go build -o ./bin/app cmd/main.go && HTTP_ADDR=:8080 ./bin/app

.PHONY: test
test:
	go test -race -cover -coverprofile=coverage.out ./...

.PHONY: lint
lint:
	golangci-lint run

.PHONY: tidy
tidy:
	go mod tidy -v

.PHONY: help
help:
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo 'Targets:'
	@echo "  ${YELLOW}dc     ${RESET} Run docker-compose"
	@echo "  ${YELLOW}run    ${RESET} Run application"
	@echo "  ${YELLOW}test   ${RESET} Run all tests"
	@echo "  ${YELLOW}lint   ${RESET} Run linters via golangci-lint"
	@echo "  ${YELLOW}tidy   ${RESET} Run tidy for go module to remove unused dependencies"
	@echo "  ${YELLOW}help   ${RESET} Show this help message"
