#!/usr/bin/env bash
set -e
[[ ! -z "$DEBUG" ]] && set -x

echo "-------------------------------------------------------------"
echo " Executing Cron Tasks: $(date)"
echo "-------------------------------------------------------------"

# If a user must be specified when executing the task, set up that option here.
# You may also leave NEXTCLOUD_EXEC_USER blank, in which case it will not be used.
if [[ -n "$NEXTCLOUD_EXEC_USER" ]]; then
    exec_user="--user $NEXTCLOUD_EXEC_USER"
fi

# Obtain the ID of the container. We do this each iteration since the Nextcloud container may be
# recreated while the cron container is still running. We will need to check for a new container ID
# each time.
containerId="$(/find-container.sh)"
if [[ -z "$containerId" ]]; then
    echo "ERROR: Unable to find the Nextcloud container"
    exit 1
fi

echo "> Nextcloud Container ID: ${containerId}"

# Loop through all shell scripts and execute the contents of those scripts in the Nextcloud
# container. It's done this way so that the user may mount more scripts to be executed in addition
# to the default ones.
cd /cron-scripts
for script in *.sh; do
    echo "> Running Script: $script"
    docker exec $exec_user -i "$containerId" bash < $script
done

echo "> Done"
