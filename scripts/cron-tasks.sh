#!/usr/bin/env bash
set -e
[[ ! -z "$DEBUG" ]] && set -x

source /nextcloud-exec.sh

echo "-------------------------------------------------------------"
echo " Executing Cron Tasks: $(date)"
echo "-------------------------------------------------------------"

# Obtain the ID of the container. We do this each iteration since the Nextcloud container may be
# recreated while the cron container is still running. We will need to check for a new container ID
# each time.
containerId="$(/find-container.sh)"
if [[ -z "$containerId" ]]; then
    echo "ERROR: Unable to find the Nextcloud container"
    exit 1
fi

echo "> Nextcloud Container ID: ${containerId}"

run_scripts_in_dir() {
    cd "$1"
    for script in *.sh; do
        echo "> Running Script: $script"
        nextcloud_exec "$containerId" "$(< $script)"
    done
}

# Loop through all shell scripts and execute the contents of those scripts in the Nextcloud
# container.
run_scripts_in_dir /cron-scripts-builtin

# If the user has mounted their own scripts, execute those as well. These are optional. It's done
# this way so that the user may mount more scripts to be executed in addition to the default ones.
if [[ -d /cron-scripts ]]; then
    run_scripts_in_dir /cron-scripts
fi

echo "> Done"
