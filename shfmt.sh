#!/bin/bash
set -eu -o pipefail

docker container run \
  --name shfmt$$ \
  --rm \
  -u "$(id -u):$(id -g)" \
  -v "$PWD":/work:ro \
  -w /work \
  mvdan/shfmt:latest "$@"
