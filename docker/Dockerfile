FROM debian:bookworm-slim AS builder
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc make git ca-certificates \
    && git clone --depth=1 https://github.com/rofl0r/microsocks /src \
    && cd /src && make

FROM debian:bookworm-slim

LABEL org.opencontainers.image.source="https://github.com/kub0-ai/openconnect-proxy"
LABEL org.opencontainers.image.description="OpenConnect VPN client with SOCKS5 proxy (microsocks) for cluster egress"
LABEL org.opencontainers.image.licenses="MIT"

RUN apt-get update && apt-get install -y --no-install-recommends \
        openconnect \
        ca-certificates \
        iproute2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/microsocks /usr/local/bin/microsocks
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 1080 — SOCKS5 proxy (routes through VPN once openconnect connects)
EXPOSE 1080

ENTRYPOINT ["/entrypoint.sh"]
