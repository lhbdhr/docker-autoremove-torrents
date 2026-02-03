#!/bin/sh

# 如果第一个参数是 daemon，则进入死循环模式
if [ "$1" = "daemon" ]; then
    # 使用环境变量 SLEEP_TIME，如果未定义则默认为 10
    INTERVAL=${SLEEP_TIME:-10}
    echo "Mode: Daemon"
    echo "Interval: ${INTERVAL}s"
    
    while true; do
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Running autoremove..."
        # 执行主程序，这里根据你 install 后的命令调用
        autoremove-torrents --conf /config/config.yml
        
        echo "Waiting for ${INTERVAL}s..."
        sleep "$INTERVAL"
    done
else
    # 如果不是 daemon 模式，则透传所有参数执行原始命令
    # 比如 docker run ... --view
    echo "Mode: Single Run"
    exec autoremove-torrents "$@"
fi