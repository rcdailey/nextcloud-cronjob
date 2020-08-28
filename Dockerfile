FROM alpine

RUN apk add --no-cache docker-cli bash tini

ENV NEXTCLOUD_EXEC_USER=www-data
ENV NEXTCLOUD_CONTAINER_NAME=
ENV NEXTCLOUD_PROJECT_NAME=
ENV NEXTCLOUD_CRON_MINUTE_INTERVAL=15
ENV NEXTCLOUD_EXEC_SHELL=bash
ENV NEXTCLOUD_EXEC_SHELL_ARGS=-c

COPY scripts/*.sh /
COPY scripts/cron-scripts /cron-scripts

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]

HEALTHCHECK --timeout=5s \
    CMD ["/healthcheck.sh"]
