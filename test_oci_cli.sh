#!/bin/bash
set -Eeu -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/tools/colored_echo.sh
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/tools/container_engine.sh

CONTAINER_ENGINE=$(detect_container_engine)
readonly CONTAINER_ENGINE

IMAGE_NAME=ghcr.io/shakiyam/oci-cli
readonly IMAGE_NAME

if [[ $CONTAINER_ENGINE == docker ]]; then
  ENGINE_OPTS=(-u "$(id -u):$(id -g)" -e USER_NAME="$(id -un)")
else
  ENGINE_OPTS=(--entrypoint=/usr/local/bin/oci --security-opt label=disable --userns=keep-id)
fi
readonly ENGINE_OPTS

WORK_DIR=$(mktemp -d)
readonly WORK_DIR
trap 'rm -rf "$WORK_DIR"' EXIT

echo 'test passphrase' >"$WORK_DIR"/passphrase.txt

if ! $CONTAINER_ENGINE container run \
  --name "test_oci_cli_$(uuidgen | head -c8)" \
  --rm \
  --pull=never \
  "${ENGINE_OPTS[@]}" \
  -e HOME=/tmp \
  -v "$WORK_DIR":/work \
  "$IMAGE_NAME" setup keys --output-dir /work --passphrase-file /work/passphrase.txt; then
  echo_error 'Test failed: oci setup keys exited with a non-zero status.'
  exit 1
fi

if [[ ! -f "$WORK_DIR"/oci_api_key.pem || ! -f "$WORK_DIR"/oci_api_key_public.pem ]]; then
  echo_error 'Test failed: API key pair was not generated.'
  exit 1
fi

echo_success 'Test passed: oci setup keys generated an API key pair successfully.'

if ! HOME="$WORK_DIR" "$SCRIPT_DIR"/oci -v </dev/null; then
  echo_error 'Test failed: oci wrapper exited with a non-zero status when stdin is not a terminal.'
  exit 1
fi

echo_success 'Test passed: oci wrapper ran successfully when stdin is not a terminal.'
