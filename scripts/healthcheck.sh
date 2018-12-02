#!/usr/bin/env bash
set -x

# Make sure cron daemon is still running
ps -o comm | grep crond || exit 1

# Make sure the target container is still running/available
docker inspect -f '{{.State.Running}}' "$(cat /tmp/containerId)" | grep true || exit 1
