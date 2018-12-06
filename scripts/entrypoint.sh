#!/usr/bin/env bash
set -e

if [[ -z "$NEXTCLOUD_CONTAINER_NAME" ]]; then
    echo "NEXTCLOUD_CONTAINER_NAME is a required variable"
    exit 1
fi

if [[ ! -z "$NEXTCLOUD_PROJECT_NAME" ]]; then
    containerName="${NEXTCLOUD_PROJECT_NAME}_"
else
    matchEnd=","
fi

containerName="${containerName}${NEXTCLOUD_CONTAINER_NAME}"

# Get the ID of the container so we can exec something in it later
export containerId=$(/find-container.sh "$containerName" "$matchEnd")

if [[ -z "$containerId" ]]; then
    echo "ERROR: Unable to find the Nextcloud container"
    exit 1
fi

echo "$containerId" > /tmp/containerId

echo "*/$NEXTCLOUD_CRON_MINUTE_INTERVAL * * * * /cron-tasks.sh $containerId" \
    > /var/spool/cron/crontabs/root

# Watch for SIGTERM (someone stops the docker container) so we can tell crond to exit
_term() {
    echo "Caught SIGTERM signal!"
    kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

exec crond -f -l 0 &
echo "Started crond"

child=$!
wait "$child"
