#!/bin/bash
set -eu -o pipefail

readonly USER_ID="$(id -u)"
readonly GROUP_ID="$(id -g)"

if [[ "$USER_ID" -eq 0 || "$GROUP_ID" -eq 0 ]]; then
  echo "No uid or gid specified."
  exit 1
fi

if [[ -z "${USER_NAME:-}" ]]; then
  echo "USER_NAME is not specified."
  exit 1
fi

groupadd -g "$GROUP_ID" "$USER_NAME"
useradd -d /home/"$USER_NAME" -s /bin/bash -u "$USER_ID" -g "$GROUP_ID" "$USER_NAME"

sudo chmod u-s /usr/sbin/useradd
sudo chmod u-s /usr/sbin/groupadd

export HOME=/home/"$USER_NAME"
exec /usr/local/bin/oci "$@"
