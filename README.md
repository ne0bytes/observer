<div align="left"><img src="https://gitlab.com/-/project/77609833/uploads/dc723798f2b351f62065c9354eaff1e6/observer_banner.svg" width="80%" alt="🔭 Observer" /></div>

![Version](https://img.shields.io/docker/v/ne0bytes/observer?sort=semver&label=Version)
![Base](https://img.shields.io/badge/Base-Alpine_3.23-0D597F?logo=alpinelinux)
![Size](https://img.shields.io/badge/Size-~78MB-green)
![License](https://img.shields.io/badge/License-Apache_2.0-blue)

> **Network & System Debugging Container**
>
> 70+ tools for debugging: nmap, tcpdump, mtr, dig, curl, httpie, grpcurl, btop, jq, zsh (vi-mode).
>
> Built-in manual: `h` or `help`

---

## 🚀 Quick Start

```bash
# Docker/Podman
docker run -it --rm ne0bytes/observer

# Kubernetes ephemeral
kubectl run observer --rm -it --image=ne0bytes/observer --restart=Never

# Debug pod's network namespace
kubectl debug -it <pod-name> --image=ne0bytes/observer --target=<container>
```

---

## ☸️ Kubernetes Deployment

### Ephemeral Pod
**When**: One-time debugging

```bash
kubectl run observer --rm -it --image=ne0bytes/observer --restart=Never
```

**Scenario**: App can't reach Redis
```bash
kubectl debug -it app-pod-xyz --image=ne0bytes/observer --target=app
nc -zv redis-service 6379
dig redis-service.default.svc.cluster.local
```

---

### DaemonSet
**When**: Need quick access across nodes/pools without spinning up pods repeatedly

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: observer
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: observer
  template:
    metadata:
      labels:
        app: observer
    spec:
      hostNetwork: true
      tolerations:
      - operator: Exists
      containers:
      - name: observer
        image: ne0bytes/observer:latest
        command: ["/bin/sleep", "infinity"]
        ## Uncomment for packet capture (tcpdump, ngrep)
        # securityContext:
        #   capabilities:
        #     add: ["NET_ADMIN", "NET_RAW"]
        resources:
          requests:
            cpu: 50m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
```

**Scenario**: Intermittent DNS timeouts - exec into specific node
```bash
kubectl exec -it -n kube-system observer-worker05-xyz -- zsh
dig @10.96.0.10 kubernetes.default.svc.cluster.local
tcpdump -i any port 53
```

---

### Deployment
**When**: Shared debugging pod for team

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: observer
spec:
  replicas: 1
  selector:
    matchLabels:
      app: observer
  template:
    metadata:
      labels:
        app: observer
    spec:
      containers:
      - name: observer
        image: ne0bytes/observer:latest
        command: ["/bin/sleep", "infinity"]
        ## Uncomment for packet capture (tcpdump, ngrep)
        # securityContext:
        #   capabilities:
        #     add: ["NET_ADMIN", "NET_RAW"]
        resources:
          requests:
            cpu: 50m
            memory: 128Mi
```

**Scenario**: Testing service connectivity
```bash
kubectl exec -it deployment/observer -- zsh
http GET http://auth-service:8080/health
grpcurl -plaintext user-service:50051 list
```

---

## 📦 What's Included

**Network**: nmap, tcpdump, mtr, dig, netcat, socat, iperf3, ethtool, conntrack, iftop, gping
**API**: httpie, curl, grpcurl, jq, yq
**System**: btop, lsof, strace, ncdu, rsync
**Shell**: zsh (vi-mode), fzf, zoxide, bat, ripgrep, eza, git-delta

Full list: `h` inside container

---

## 🔒 Security

**Known vulnerabilities** (unfixable - awaiting upstream patches):

- ⚠️ **CRITICAL** [CVE-2026-22184](https://nvd.nist.gov/vuln/detail/CVE-2026-22184) - zlib 1.3.1-r2 (system dependency)
- ⚠️ **HIGH** [CVE-2025-22868](https://nvd.nist.gov/vuln/detail/CVE-2025-22868) - golang.org/x/oauth2 0.14.0 (grpcurl dependency)

Both will be updated when upstream Alpine packages are patched.

---

## 🔗 Resources

- **Docker Hub**: https://hub.docker.com/r/ne0bytes/observer
- **Repository**: https://gitlab.com/ne0bytes/tooling/containers
- **Manual**: [MANUAL.md](./MANUAL.md)

---

Built with ❤️ by **[NΞO](https://gitlab.com/ne0b)** | **HAPPY DEBUGGING!** <img src="https://gitlab.com/-/project/77609833/uploads/392572b2d757579a44cce3d4693002bc/observer_glyph.svg" width="15" align="center" alt="🔭" />
