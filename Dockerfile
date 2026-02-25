# Build stage: install yt-dlp with Python in Alpine
FROM alpine:3.22 AS builder

RUN apk add --no-cache python3 py3-pip curl \
    && pip3 install --break-system-packages yt-dlp

# Final stage
FROM n8nio/n8n:latest

USER root

# Copy Python and yt-dlp from builder
COPY --from=builder /usr/bin/python3 /usr/bin/python3
COPY --from=builder /usr/lib/python3.12 /usr/lib/python3.12
COPY --from=builder /usr/lib/libpython3.12.so* /usr/lib/
COPY --from=builder /usr/bin/yt-dlp /usr/bin/yt-dlp

# Copy static ffmpeg binaries
COPY --from=mwader/static-ffmpeg:latest /ffmpeg /usr/local/bin/ffmpeg
COPY --from=mwader/static-ffmpeg:latest /ffprobe /usr/local/bin/ffprobe

WORKDIR /home/node/packages/cli
ENTRYPOINT []

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]