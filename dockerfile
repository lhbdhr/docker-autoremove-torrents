FROM python:3.14-alpine

WORKDIR /app

RUN apk add --no-cache git && \
    git clone https://github.com/jerrymakesjelly/autoremove-torrents.git . && \
    # 关键：先安装 setuptools 和项目声明的所有依赖
    pip install --no-cache-dir setuptools && \
    pip install --no-cache-dir -r requirements.txt && \
    python3 setup.py install && \
    apk del git && \
    rm -rf /root/.cache

VOLUME /config

ENTRYPOINT ["autoremove-torrents"]

CMD ["--conf", "/config/config.yml"]
