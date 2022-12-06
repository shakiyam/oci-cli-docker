#!/bin/bash
set -eu -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/colored_echo.sh

if [[ $(command -v docker) ]]; then
  DOCKER=docker
elif [[ $(command -v podman) ]]; then
  DOCKER=podman
else
  echo_error "Neither docker nor podman is installed."
  exit 1
fi
readonly DOCKER

if [[ $# -ne 2 ]]; then
  echo_error "Usage: check_for_image_updates.sh image_name1 image_name2"
  exit 1
fi
readonly IMAGE_NAME1=$1
readonly IMAGE_NAME2=$2

echo_info "$IMAGE_NAME1 and $IMAGE_NAME2"
$DOCKER image pull -q "$IMAGE_NAME1"
IMAGE_ID1="$($DOCKER image inspect -f "{{.Id}}" "$IMAGE_NAME1")"
readonly IMAGE_ID1
$DOCKER image pull -q "$IMAGE_NAME2"
IMAGE_ID2="$($DOCKER image inspect -f "{{.Id}}" "$IMAGE_NAME2")"
readonly IMAGE_ID2
if [[ "$IMAGE_ID1" != "$IMAGE_ID2" ]]; then
  echo_warn "$IMAGE_NAME1 and $IMAGE_NAME2 are not the same."
  exit 2
fi
echo_success "$IMAGE_NAME1 and $IMAGE_NAME2 are the same."
