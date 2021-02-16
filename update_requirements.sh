#!/bin/bash
set -eu -o pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
[[ -e "$script_dir/requirements.txt" ]] || touch "$script_dir/requirements.txt"
docker container run \
  --name update_requirements$$ \
  --rm \
  -u "$(id -u):$(id -g)" \
  -v "$script_dir/requirements-to-freeze.txt":/work/requirements-to-freeze.txt:ro \
  -v "$script_dir/requirements.txt":/work/requirements.txt \
  -w /work \
  python:3-slim-buster sh -c 'export HOME=/tmp && pip install -r requirements-to-freeze.txt --no-warn-script-location && pip freeze > requirements.txt'
