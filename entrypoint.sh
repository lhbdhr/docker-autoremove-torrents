#!/bin/sh

if [ "$1" = "daemon" ]; then
    INTERVAL=${SLEEP_TIME:-10}
    
    echo "--- Daemon Mode Started ---"
    echo "Interval: ${INTERVAL}s"

    # 动态拼接参数
    ARGS="--conf ${CONF_PATH:-/config/config.yml}"
    
    if [ "$DRY_RUN" = "true" ]; then
        ARGS="$ARGS --view"
        echo "Option: Dry-run enabled (View only)"
    fi

    if [ -n "$TASK_NAME" ]; then
        ARGS="$ARGS --task $TASK_NAME"
        echo "Option: Target Task -> $TASK_NAME"
    fi

    if [ -n "$LOG_PATH" ]; then
        ARGS="$ARGS --log $LOG_PATH"
        echo "Option: Log Path -> $LOG_PATH"
    fi

    if [ "$DEBUG_MODE" = "true" ]; then
        ARGS="$ARGS --debug"
        echo "Option: Debug mode enabled"
    fi

    while true; do
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Executing: autoremove-torrents $ARGS"
        autoremove-torrents $ARGS
        
        echo "Sleeping for ${INTERVAL}s..."
        sleep "$INTERVAL"
    done
else
    exec autoremove-torrents "$@"
fi