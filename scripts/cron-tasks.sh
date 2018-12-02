#!/usr/bin/env bash
set -ex

containerName="$1"
docker exec "$containerName" php -f /var/www/html/cron.php
