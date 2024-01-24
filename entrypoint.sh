#!/bin/bash
set -eu -o pipefail

USER_ID="$(id -u)"
readonly USER_ID
GROUP_ID="$(id -g)"
readonly GROUP_ID

if [[ "$USER_ID" -eq 0 || "$GROUP_ID" -eq 0 ]]; then
  echo "Running with super user privileges is prohibited. Please use the -u option to specify a UID and GID that is not a super user."
  exit 1
fi

if [[ -z "${USER_NAME:-}" ]]; then
  echo "USER_NAME is not specified."
  exit 1
fi

if [[ $HOME == "/" ]]; then
  echo "HOME is not specified."
  exit 1
fi

groupadd -g "$GROUP_ID" "$USER_NAME"
useradd -d "$HOME" -s /bin/bash -u "$USER_ID" -g "$GROUP_ID" "$USER_NAME" &>/dev/null

exec /usr/local/bin/oci "$@"
