MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.SUFFIXES:

ALL_TARGETS := $(shell egrep -o ^[0-9A-Za-z_-]+: $(MAKEFILE_LIST) | sed 's/://')

.PHONY: $(ALL_TARGETS)

all: hadolint shellcheck shfmt update_requirements build ## Lint, update requirements.txt, and build
	@:

build: ## Build an image from a Dockerfile
	@echo -e "\033[36m$@\033[0m"
	@./build.sh

hadolint: ## Lint Dockerfile
	@echo -e "\033[36m$@\033[0m"
	@./hadolint.sh Dockerfile

shellcheck: ## Lint shell scripts
	@echo -e "\033[36m$@\033[0m"
	@./shellcheck.sh oci *.sh

shfmt: ## Lint shell scripts
	@echo -e "\033[36m$@\033[0m"
	@./shfmt.sh -l -d -i 2 -ci -bn oci *.sh

update_requirements: ## Update requirements.txt
	@echo -e "\033[36m$@\033[0m"
	@./pip-compile.sh --upgrade

help: ## Print this help
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9A-Za-z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
