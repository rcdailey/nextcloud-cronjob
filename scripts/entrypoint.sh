#!/usr/bin/env bash
set -e

if [[ -z "$NEXTCLOUD_CONTAINER_NAME" ]]; then
    echo "NEXTCLOUD_CONTAINER_NAME is a required variable"
    exit 1
fi

echo "*/$NEXTCLOUD_CRON_MINUTE_INTERVAL * * * * /cron-tasks.sh" \
    > /var/spool/cron/crontabs/root

echo "Starting crond"
exec crond -f -l 0
