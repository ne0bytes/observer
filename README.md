<div align="left"><img src="https://gitlab.com/-/project/77609833/uploads/dc723798f2b351f62065c9354eaff1e6/observer_banner.svg" width="80%" alt="🔭 Observer" /></div>

![Version](https://img.shields.io/docker/v/ne0bytes/observer?sort=semver&label=Version)
![Base](https://img.shields.io/badge/Base-Alpine_3.23-0D597F?logo=alpinelinux)
![Size](https://img.shields.io/docker/image-size/ne0bytes/observer?label=Size)
![License](https://img.shields.io/badge/License-Apache_2.0-blue)

## What Is This

A debugging container with network and system tools. Like nicolaka/netshoot, but with a better shell and built-in documentation.

**What's different:**
- **Modern shell**: zsh with vi-mode, fuzzy history search (fzf), syntax highlighting, and z-jumping between directories
- **Built-in manual**: `h` command shows tool usage and examples. No more Googling tcpdump flags during incidents
- **Curated toolset**: Standard network tools (tcpdump, nmap, mtr, dig) plus modern alternatives (httpie, grpcurl, gping, btop)

**When to use this over alternatives:**
- You're tired of basic sh/bash in debug containers
- You want tool documentation without leaving the container
- You need both classic tools and modern replacements

**When to use something else:**
- You need the absolute smallest image → use busybox
- You want battle-tested and widely deployed → use netshoot
- You need Windows container debugging → this won't work

---

## 🚀 Quick Start

**Docker/Podman**
```bash
docker run -it --rm ne0bytes/observer
```

**Docker - Debug container's network**
```bash
docker run -it --rm --network container:<container-id> ne0bytes/observer
```

**Kubernetes - Ephemeral pod**
```bash
kubectl run observer --rm -it --image=ne0bytes/observer --restart=Never
```

**Kubernetes - Debug existing pod**
```bash
kubectl debug -it <pod-name> --image=ne0bytes/observer --target=<container>
```

---

## ☸️ Kubernetes Deployment

For a persistent debugging pod:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: observer
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: observer
  namespace: observer
  labels:
    app: observer
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
      terminationGracePeriodSeconds: 0
      # hostNetwork: true  # Uncomment to access host network interfaces
      containers:
      - name: observer
        image: ne0bytes/observer:latest
        imagePullPolicy: Always
        resources:
          requests:
            cpu: "50m"
            memory: "128Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"
        # securityContext:
        #   capabilities:
        #     add: ["NET_RAW"]
        #   allowPrivilegeEscalation: false
```

**Access:**
```bash
kubectl exec -it -n observer deployment/observer -- zsh
```

**Notes:**
- Uncomment `hostNetwork: true` if you need to debug node-level networking
- Uncomment `NET_RAW` capability if you need packet capture (tcpdump, nmap, ping)

---

## 📦 What's Included

- **Network**: nmap, tcpdump, mtr, dig, netcat, socat, iperf3, ethtool, conntrack, iftop, gping
- **API**: httpie, curl, grpcurl, jq, yq
- **System**: btop, lsof, strace, ncdu, rsync
- **Shell**: zsh (vi-mode), fzf, zoxide, bat, ripgrep, eza, git-delta

Full list and examples: `h` or `help` inside container

---

## 🔒 Security

**This is a debugging tool.** Use it for ephemeral troubleshooting, not as a long-running service.

**Known vulnerabilities** (awaiting upstream patches):
- ⚠️ **CRITICAL** [CVE-2026-22184](https://nvd.nist.gov/vuln/detail/CVE-2026-22184) - zlib 1.3.1-r2 (Alpine system dependency)
- ⚠️ **HIGH** [CVE-2025-22868](https://nvd.nist.gov/vuln/detail/CVE-2025-22868) - golang.org/x/oauth2 0.14.0 (grpcurl dependency)

These will be patched when Alpine/Go upstream releases fixes. For ephemeral debugging sessions, the risk is minimal. For persistent deployments, assess your risk tolerance.

---

## 🔗 Resources

- **Docker Hub**: [ne0bytes/observer](https://hub.docker.com/r/ne0bytes/observer)
- **Source Code**: [GitLab Repository](https://gitlab.com/ne0bytes/tooling/observer)
- **Issues**: [Report bugs or request features](https://gitlab.com/ne0bytes/tooling/observer/-/issues)
- **Documentation**: [MANUAL.md](./MANUAL.md)

---

**Maintenance**: Actively maintained. Updates follow Alpine stable releases.

Built with ❤️ by **[NΞO](https://gitlab.com/ne0b)** | **HAPPY DEBUGGING!** <img src="https://gitlab.com/-/project/77609833/uploads/392572b2d757579a44cce3d4693002bc/observer_glyph.svg" width="15" align="center" alt="🔭" />
