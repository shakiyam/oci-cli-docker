#!/bin/bash
set -Eeu -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/colored_echo.sh

if command -v docker &>/dev/null; then
  docker container run \
    --name "pip-compile_$(uuidgen | head -c8)" \
    --rm \
    -e HOME=/tmp \
    -u "$(id -u):$(id -g)" \
    -v "$PWD":/work \
    -w /work \
    ghcr.io/shakiyam/pip-tools pip-compile "$@"
elif command -v podman &>/dev/null; then
  podman container run \
    --name "pip-compile_$(uuidgen | head -c8)" \
    --rm \
    --security-opt label=disable \
    -e HOME=/tmp \
    -v "$PWD":/work \
    -w /work \
    ghcr.io/shakiyam/pip-tools pip-compile "$@"
else
  echo_error 'Neither docker nor podman is installed.'
  exit 1
fi
