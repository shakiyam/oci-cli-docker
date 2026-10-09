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

if [[ $# -lt 1 ]]; then
  echo_error 'Usage: pip_licenses.sh image_name [pip-licenses options...]'
  exit 1
fi
IMAGE_NAME="$1"
readonly IMAGE_NAME
shift

# Requires sh and pip in the image.
# shellcheck disable=SC2016
$CONTAINER_ENGINE container run \
  --name "pip_licenses_$(uuidgen | head -c8)" \
  --rm \
  -u 0 \
  --entrypoint sh \
  "$IMAGE_NAME" -c 'pip install --quiet --root-user-action=ignore pip-licenses && pip-licenses "$@"' sh "$@"
