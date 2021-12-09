#!/bin/bash
set -eu -o pipefail

docker container run \
  --name hadolint$$ \
  --rm \
  -u "$(id -u):$(id -g)" \
  -v "$PWD":/work:ro \
  -w /work \
  hadolint/hadolint hadolint "$@"
