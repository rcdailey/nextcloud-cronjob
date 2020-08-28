#!/usr/bin/env bash
set -e
[[ ! -z "$DEBUG" ]] && set -x

source /nextcloud-exec.sh

if [[ -z "$NEXTCLOUD_CONTAINER_NAME" ]]; then
    echo "NEXTCLOUD_CONTAINER_NAME is a required variable"
    exit 1
fi

# Print info about how we will look for Nextcloud
if [[ -n "$NEXTCLOUD_PROJECT_NAME" ]]; then
    echo "Will search for Nexcloud container as a Docker Compose service"
    echo "Project: $NEXTCLOUD_PROJECT_NAME, Service: $NEXTCLOUD_CONTAINER_NAME"
else
    echo "Container Name: $NEXTCLOUD_CONTAINER_NAME"
fi

# Do an initial search for the container to rule out any configuration problems
containerId="$(/find-container.sh)"
if [[ -z "$containerId" ]]; then
    echo "ERROR: Unable to find the Nextcloud container"
    exit 1
else
    echo "Found Nextcloud container with ID $containerId"
fi

# Verify the chosen shell exists in the Nextcloud container
if ! nextcloud_exec_no_shell "$containerId" sh -c "command -v \"$NEXTCLOUD_EXEC_SHELL\"" >/dev/null 2>&1
then
    echo "ERROR: Shell \"$NEXTCLOUD_EXEC_SHELL\" does not exist in the Nextcloud container"
    exit 1
else
    echo "Chosen shell \"$NEXTCLOUD_EXEC_SHELL\" was found in the Nextcloud container"
fi

echo "*/$NEXTCLOUD_CRON_MINUTE_INTERVAL * * * * /cron-tasks.sh" \
    > /var/spool/cron/crontabs/root

echo "Starting crond"
exec crond -f -l 0
