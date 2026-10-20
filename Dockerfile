# Stremio streaming server (official server.js v4.20.16) on Render free tier
FROM node:20-slim

# ffmpeg + ffprobe (Debian official packages) for transcoding support.
# server.js looks for binaries named "ffmpeg"/"ffprobe" sitting next to itself.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Official Stremio server build (pinned version, checksum-verified at build time)
RUN curl -fsSL -o /app/server.js https://dl.strem.io/server/v4.20.16/desktop/server.js \
    && echo "88e887f058765f0e3dbc636829e7687ab80759c392eb9a64df457c8f9fc86e28  /app/server.js" | sha256sum -c - \
    && cp /usr/bin/ffmpeg /usr/bin/ffprobe /app/ \
    && chmod +x /app/ffmpeg /app/ffprobe

# Render injects $PORT; server.js honors process.env.PORT (falls back to 11470)
EXPOSE 11470
CMD ["node", "server.js"]
