FROM n8nio/n8n:latest

USER root

RUN apk add --update --no-cache yt-dlp ffmpeg

WORKDIR /home/node/packages/cli
ENTRYPOINT []

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]