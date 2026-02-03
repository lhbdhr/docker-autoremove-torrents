FROM python:3.12-alpine

ARG APP_VERSION
WORKDIR /app

RUN apk add --no-cache git && \
    git clone --branch ${APP_VERSION} --single-branch https://github.com/jerrymakesjelly/autoremove-torrents.git . && \
    pip install --no-cache-dir setuptools && \
    pip install --no-cache-dir -r requirements.txt && \
    python3 setup.py install && \
    apk del git && \
    rm -rf /root/.cache

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME /config
ENTRYPOINT ["/entrypoint.sh"]
CMD ["daemon"]