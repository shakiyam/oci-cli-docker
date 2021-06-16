#!/bin/bash
set -eu -o pipefail

docker container run \
  --name pip-compile$$ \
  --rm \
  -u "$(id -u):$(id -g)" \
  -v "$PWD":/work \
  -w /work \
  -e HOME=/tmp \
  shakiyam/pip-tools pip-compile "$@"
