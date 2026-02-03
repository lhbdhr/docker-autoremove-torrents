FROM python:3.12-alpine

# 接收从 Action 传过来的版本号
ARG APP_VERSION

WORKDIR /app

RUN apk add --no-cache git && \
    git clone --branch ${APP_VERSION} --single-branch https://github.com/jerrymakesjelly/autoremove-torrents.git . && \
    pip install --no-cache-dir setuptools && \
    pip install --no-cache-dir -r requirements.txt && \
    python3 setup.py install && \
    apk del git && \
    rm -rf /root/.cache

VOLUME /config
ENTRYPOINT ["autoremove-torrents"]
CMD ["--conf", "/config/config.yml"]