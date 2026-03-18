# openconnect-proxy

OpenConnect VPN client with SOCKS5 proxy ([microsocks](https://github.com/rofl0r/microsocks)) for cluster egress anonymization.

Supports all OpenConnect protocols: GlobalProtect (`gp`), AnyConnect (`anyconnect`), Fortinet, F5, Pulse, Juniper, and more.

## Docker (full routing)

```bash
cp .env.example .env
# edit .env with your portal, user, and protocol
docker compose up -d

# Connect to VPN interactively (prompts for password)
docker exec -it openconnect openconnect --protocol=$OC_PROTOCOL --user=$OC_USER --passwd-on-stdin $OC_PORTAL

# SOCKS5 now at localhost:1080 — all traffic routes through VPN
curl --proxy socks5://localhost:1080 https://ipinfo.io
```

## Kubernetes (exec mode)

```bash
# Scale up the deployment
kubectl scale deploy/openconnect -n networking --replicas=1

# Connect to VPN inside the pod
kubectl exec -it deploy/openconnect -n networking -- \
  openconnect --protocol=gp --user=your_user --passwd-on-stdin vpn.example.com

# Exec commands through VPN
kubectl exec deploy/openconnect -n networking -- curl https://ipinfo.io

# SOCKS5 via port-forward
kubectl port-forward svc/openconnect 1080:1080 -n networking
curl --proxy socks5://localhost:1080 https://ipinfo.io

# Scale back down
kubectl scale deploy/openconnect -n networking --replicas=0
```

Or via k0 CLI:

```bash
k0 proxy openconnect connect vpn.example.com --protocol gp
k0 proxy openconnect exec -- curl https://ipinfo.io
k0 proxy openconnect disconnect
```

## Image

`ghcr.io/kub0-ai/openconnect-proxy:latest` — multi-arch (amd64 + arm64)

## Protocol Reference

| `--protocol` | VPN Type |
|---|---|
| `gp` | Palo Alto GlobalProtect |
| `anyconnect` | Cisco AnyConnect / Secure Client |
| `fortinet` | Fortinet FortiClient SSL VPN |
| `f5` | F5 BIG-IP APM |
| `pulse` | Pulse Secure / Ivanti |
| `nc` | Juniper Network Connect |
| `array` | Array Networks SSL VPN |
