MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
ALL_TARGETS := $(shell grep -E -o ^[0-9A-Za-z_-]+: $(MAKEFILE_LIST) | sed 's/://')
.PHONY: $(ALL_TARGETS)
.DEFAULT_GOAL := help

all: check_for_updates format lint build install ## Check for updates, format, lint, build, and install

actionlint: ## Lint GitHub Actions workflow files
	@echo -e "\033[36m$@\033[0m"
	@./tools/actionlint.sh

build: ## Build an image from a Dockerfile
	@echo -e "\033[36m$@\033[0m"
	@./tools/build.sh ghcr.io/shakiyam/oci-cli

check_for_action_updates: ## Check for GitHub Actions updates
	@echo -e "\033[36m$@\033[0m"
	@./tools/check_for_action_updates.sh actions/checkout
	@./tools/check_for_action_updates.sh docker/build-push-action
	@./tools/check_for_action_updates.sh docker/login-action
	@./tools/check_for_action_updates.sh docker/setup-buildx-action
	@./tools/check_for_action_updates.sh docker/setup-qemu-action

check_for_library_updates: ## Check for library updates
	@echo -e "\033[36m$@\033[0m"
	@./tools/pip-compile.sh --upgrade --strip-extras

check_for_updates: check_for_action_updates check_for_library_updates ## Check for updates to all dependencies

dockerfmt: ## Format Dockerfile
	@echo -e "\033[36m$@\033[0m"
	@./tools/dockerfmt.sh -i 2 -n -w Dockerfile

format: dockerfmt shfmt yamlfmt ## Run all formatting

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

lint: actionlint hadolint shellcheck zizmor ## Run all linting

shellcheck: ## Lint shell scripts
	@echo -e "\033[36m$@\033[0m"
	@./tools/shellcheck.sh oci ./*.sh tools/*.sh

shfmt: ## Format shell scripts
	@echo -e "\033[36m$@\033[0m"
	@./tools/shfmt.sh -l -w -i 2 -ci -bn oci ./*.sh tools/*.sh

yamlfmt: ## Format YAML files
	@echo -e "\033[36m$@\033[0m"
	@./tools/yamlfmt.sh .github/zizmor.yml .github/workflows/*.yml

zizmor: ## Lint GitHub Actions workflows for security issues
	@echo -e "\033[36m$@\033[0m"
	@./tools/zizmor.sh .
