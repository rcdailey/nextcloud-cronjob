#!/usr/bin/env bash
set -e

echo "-------------------------------------------------------------"
echo " Executing Cron Tasks: $(date)"
echo "-------------------------------------------------------------"

# Loop through all shell scripts and execute the contents of those scripts in the Nextcloud
# container. It's done this way so that the user may mount more scripts to be executed in addition
# to the default ones.
cd /cron-scripts
for script in *.sh; do
    echo "> Running Script: $script"
    docker exec -i "$1" bash < $script
done

echo "> Done"
