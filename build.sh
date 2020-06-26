#!/bin/bash
set -eu -o pipefail

readonly IMAGE_NAME='shakiyam/oci-cli'
readonly CURRENT_IMAGE="$(docker image ls -q $IMAGE_NAME:latest)"
docker image build \
  -t "$IMAGE_NAME" \
  "$(dirname "$0")"
readonly LATEST_IMAGE="$(docker image ls -q $IMAGE_NAME:latest)"
if [[ "$CURRENT_IMAGE" != "$LATEST_IMAGE" ]]; then
  docker image tag $IMAGE_NAME:latest $IMAGE_NAME:"$(date +%Y%m%d%H%S)"
fi
