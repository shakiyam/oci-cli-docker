MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
ALL_TARGETS := $(shell grep -E -o ^[0-9A-Za-z_-]+: $(MAKEFILE_LIST) | sed 's/://')
.PHONY: $(ALL_TARGETS)
.DEFAULT_GOAL := help

all: check_for_updates lint build install ## Check for updates, lint, build, and install

build: ## Build an image from a Dockerfile
	@echo -e "\033[36m$@\033[0m"
	@./tools/build.sh ghcr.io/shakiyam/oci-cli

check_for_library_updates: ## Check for library updates
	@echo -e "\033[36m$@\033[0m"
	@./tools/pip-compile.sh --upgrade --strip-extras

check_for_updates: check_for_library_updates ## Check for updates to all dependencies

hadolint: ## Lint Dockerfile
	@echo -e "\033[36m$@\033[0m"
	@./tools/hadolint.sh Dockerfile

help: ## Print this help
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9A-Za-z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install OCI CLI
	@echo -e "\033[36m$@\033[0m"
	@sudo cp oci /usr/local/bin/oci
	@sudo chmod +x /usr/local/bin/oci

lint: hadolint shellcheck shfmt ## Lint all dependencies

shellcheck: ## Lint shell scripts
	@echo -e "\033[36m$@\033[0m"
	@./tools/shellcheck.sh oci tools/*.sh

shfmt: ## Lint shell scripts
	@echo -e "\033[36m$@\033[0m"
	@./tools/shfmt.sh -l -d -i 2 -ci -bn oci tools/*.sh
