#!/usr/bin/env bash

nextcloud_exec_no_shell() {
    containerId="$1"; shift

    # If a user must be specified when executing the task, set up that option here.
    # You may also leave NEXTCLOUD_EXEC_USER blank, in which case it will not be used.
    if [[ -n "$NEXTCLOUD_EXEC_USER" ]]; then
        exec_user="--user $NEXTCLOUD_EXEC_USER"
    fi

    docker exec $exec_user "$containerId" "$@"
}

nextcloud_exec() {
    containerId="$1"; shift
    nextcloud_exec_no_shell "$containerId" "$NEXTCLOUD_EXEC_SHELL" $NEXTCLOUD_EXEC_SHELL_ARGS "$@"
}
