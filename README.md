# docker-autoremove-torrents

autoremove-torrents build

## docker-compose.yml

```yml
services:
  autoremove:
    image: lhbdhr/autoremove-torrents:latest
    container_name: autoremove-torrents
    network_mode: host
    restart: unless-stopped
    environment:
      - SLEEP_TIME=10 # 运行频率
      - DRY_RUN=false # 改为 true 则只打印不删除
      - CONF_PATH=/config/config.yml
      - TASK_NAME=my_task # 指定 config.yml 里的任务名，留空则执行所有任务
      - LOG_PATH=/config/logs # 指定日志目录/文件路径，留空则不记录到文件
      - DEBUG_MODE=false # 改为 true 开启详细调试日志
    volumes:
      - ./config:/config
      - /mnt/data/downloads/torrents:/torrents
```

## config.yml

```yml
my_task:
  client: qbittorrent
  host: http://127.0.0.1:8080
  username: user
  password: pass
  strategies:
    delete_by_ratio:
      status:
        - downloading
      remove: progress > 50 and ratio < 0.4
    delete_by_ratio_5G:
      status:
        - downloading
      remove: progress > 20 and ratio < 0.1 and (size < 5 or size = 5)
    delete_by_ratio_10G:
      status:
        - downloading
      remove: progress > 20 and ratio < 0.1 and size > 5 and (size < 10 or size = 10)
    delete_by_ratio_30G:
      status:
        - downloading
      remove: progress > 15 and ratio < 0.1 and size > 10 and (size < 30 or size = 30)
    delete_by_ratio_60G:
      status:
        - downloading
      remove: progress > 15 and ratio < 0.1 and size > 30 and (size < 60 or size = 60)
    # 删除已出种的种子
    delete_by_seeder:
      status:
        - downloading
      remove: seeder > 3 and progress < 90
    # 移除下载人数少的种子
    # download 不能删除，必须有数据后再判断，
    # 否则所有种子刚添加时，connected_leecher 都是 0
    delete_by_leecher:
      status:
        - downloading
      remove: connected_leecher < 5 and download > 1 and progress < 90
    delete_by_restspace:
      categories:
        - rss
      free_space:
        min: 20 # size in GiB
        path: /torrents # This Path MUST EXIST
        action: remove-inactive-seeds
  delete_data: true
```
