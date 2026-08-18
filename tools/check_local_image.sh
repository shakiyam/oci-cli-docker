#!/bin/bash
set -Eeu -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/colored_echo.sh
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/container_engine.sh

CONTAINER_ENGINE=$(detect_container_engine)
readonly CONTAINER_ENGINE

if [[ $# -ne 1 ]]; then
  echo_error 'Usage: check_local_image.sh image_name'
  exit 1
fi
IMAGE_NAME="$1"
readonly IMAGE_NAME

if [[ -z "$($CONTAINER_ENGINE image ls --quiet "$IMAGE_NAME":latest)" ]]; then
  echo_error "Image $IMAGE_NAME:latest not found locally. Run 'make build' first."
  exit 1
fi
