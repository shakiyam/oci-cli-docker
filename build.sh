#!/bin/bash
set -eu -o pipefail

IMAGE_NAME='shakiyam/oci-cli'
readonly IMAGE_NAME
CURRENT_IMAGE="$(docker image ls -q $IMAGE_NAME:latest)"
readonly CURRENT_IMAGE
docker image build \
  -t "$IMAGE_NAME" \
  "$(dirname "$0")"
LATEST_IMAGE="$(docker image ls -q $IMAGE_NAME:latest)"
readonly LATEST_IMAGE
if [[ "$CURRENT_IMAGE" != "$LATEST_IMAGE" ]]; then
  docker image tag $IMAGE_NAME:latest $IMAGE_NAME:"$(date +%Y%m%d%H%S)"
fi
