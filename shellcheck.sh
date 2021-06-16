#!/bin/bash
set -eu -o pipefail

docker container run \
  --name shellcheck$$ \
  --rm \
  -u "$(id -u):$(id -g)" \
  -v "$PWD":/mnt:ro \
  koalaman/shellcheck:stable "$@"
