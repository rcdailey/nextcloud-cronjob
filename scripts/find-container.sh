#!/usr/bin/env bash
set -e

containerName="$1"
matchEnd="$2"

docker ps --format '{{.Names}},{{.ID}}' | \
    egrep "^${containerName}${matchEnd}" | \
    awk '{split($0,a,","); print a[2]}'
