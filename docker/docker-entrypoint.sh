#!/bin/bash
set -euo pipefail

# Start SOCKS5 proxy on :1080.
# Once openconnect connects (via kubectl/docker exec), all microsocks traffic
# routes through the VPN tun interface automatically.
microsocks -p 1080 &
MICROSOCKS_PID=$!

echo "[openconnect-proxy] SOCKS5 listening on :1080"
echo "[openconnect-proxy] Connect VPN with:"
echo "  kubectl exec <pod> -- openconnect --protocol=\${OC_PROTOCOL:-gp} --user=\${OC_USER:-} --passwd-on-stdin \${OC_PORTAL:-}"
echo "  docker exec -it openconnect openconnect --protocol=\${OC_PROTOCOL:-gp} --user=\${OC_USER:-} --passwd-on-stdin \${OC_PORTAL:-}"

wait $MICROSOCKS_PID
