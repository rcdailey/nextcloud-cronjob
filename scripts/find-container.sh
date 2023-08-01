#!/usr/bin/env bash
set -e

if [[ ! -z "$NEXTCLOUD_PROJECT_NAME" ]]; then
    containerName="${NEXTCLOUD_PROJECT_NAME}[_-]"
    matchEnd="[\._-]\d+"
else
    matchEnd=","
fi

containerName="${containerName}${NEXTCLOUD_CONTAINER_NAME}"

# Get the ID of the first matching container so we can exec something in it later
docker ps --format '{{.Names}},{{.ID}}' | \
    egrep "^${containerName}${matchEnd}" | \
    awk '{split($0,a,","); print a[2]}' | \
    head -n 1
