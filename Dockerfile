# syntax=docker/dockerfile:1.7
# 🏗️ Base: Alpine 3.23
FROM alpine:3.23
COPY <<'EOF' /etc/observer/banner.braille
#
# ⠀⡴⠛⢻⣶⣤⡀
# ⡞⠀⠀⠇⠀⠀⠀⠉⠛⠿⣿⣿⣿⣿⣿⣿⣿⡄
# ⠷⣤⣶⠀⢀⡜⠀⠀⠀⠀⠀⢹⢿⣿⣿⣿⣿⡇⠀ ⡟⣿⢈⣋⡃⣟⣹
# ⠀⠀⠉⣶⣿⣦⠄⠀⣀⣀⢠⣏⣀⣈⠉⠛⢿⡇⠀⠀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡀⠀⣀⣀⣀⣀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀
# ⠀⠀⠀⣿⣿⣿⠀⠀⠀⣴⣿⡿⠿⠿⠀⠀⢀⣥⣄⡸⠿⡿⠿⠿⠿⣿⣿⠀⠀⠀⠀⢸⣿⡿⠿⠿⠿⠿⠿⠿⠟⠀⠀⠀⣿⣿⣿⣿⡿⠿⠿⠿⠟⠀⠀⣿⣿⠿⠿⠿⢿⣿⣿⣿⡇⠀⢿⣿⣿⣿⣇⠀⠀⠀⢰⣿⣿⠀⠀⢸⣿⣿⣿⣿⠿⠿⠿⠟⠀⠀⢸⣿⡿⠿⠿⢿⣿⣿⣿⣿
# ⠀⠀⠀⣿⣿⣿⠀⠀⣤⢻⣿⣧⠀⠀⣿⣿⣿⡎⠛⠇⣠⡇⠀⠀⠀⣿⣿⠀⠀⠀⠀⢸⣿⣧⣤⣤⣤⣤⣤⣤⣄⠀⠀⠀⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⢸⣿⣿⣿⡇⠀⠘⣿⣿⣿⣿⡄⠀⠀⣾⣿⠇⠀⠀⢸⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⢸⣿⣿⣿⣿
# ⠀⠀⠀⣿⣿⣿⣀⣾⡿⣷⡝⣿⣷⡀⣿⣿⣿⡇⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⢻⣿⣿⣿⣧⠀⢸⣿⡿⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⡿
# ⠀⠀⠀⣿⣿⠟⢿⡟⠁⣿⡟⠈⢻⣿⠻⣿⣿⡇⠀⢸⣿⣿⣿⣿⠀⠀⠀⣿⣿⠀⠀⠘⠛⠛⠛⠛⠛⠛⠛⣿⣿⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠀⠹⣿⣷⡀⠀⠀⠀⠈⣿⣿⣿⣿⣆⣿⣿⠃⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⡇⠈⢿⣿⣆ 
# ⠀⠀⠀⣿⠋⠀⣴⣿⣿⡆⢸⣿⣿⣆⠀⠙⣿⠇⠀⢸⣿⣿⣿⣿⣦⣤⣴⣿⣿⠀⠀⠀⢠⣤⣤⣤⣤⣤⣴⣿⣿⠀⠀⣿⣿⣦⣤⣤⣤⣤⣤⣤⣤⠀⠀⣿⣿⣿⣿⠀⠀⠘⣿⣿⡄⠀⠀⠀⢹⣿⣿⣿⣿⣿⡟⠀⠀⠀⢸⣿⣷⣤⣤⣤⣤⣤⣤⣤⠀⠀⢸⣿⣿⣿⡇⠀⠈⢻⣿⣧
# ⠀⠀⢀⣷⠖⠈⠉⠉⠉⢱⡎⠉⠉⠉⠁⠶⣾⡀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠀⠀⠉⠉⠉⠉⠀⠀⠀⠈⠉⠁⠀⠀⠀⠀⠉⠉⠉⠉⠉⠁⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠀⠀⠈⠉⠉⠉⠁⠀⠀⠀⠉⠉
#
EOF

# 🏷️ Metadata
ARG VERSION=latest BUILD_DATE VCS_REF
LABEL org.opencontainers.image.title="observer" \
      org.opencontainers.image.description="Network debugging and reconnaissance container" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.vendor="ne0bytes" \
      org.opencontainers.image.authors="ne0bytes" \
      org.opencontainers.image.base.name="alpine:3.23" \
      org.opencontainers.image.url="docker://docker.io/ne0bytes/observer" \
      org.opencontainers.image.source="https://gitlab.com/ne0bytes/tooling/observer" \
      org.opencontainers.image.documentation="https://gitlab.com/ne0bytes/tooling/observer/-/raw/main/README.md" \
      org.opencontainers.image.licenses="Apache 2.0"

# 📦 Install Packages
ARG CORE="ca-certificates coreutils tzdata busybox-extras tar py3-urllib3@edge"
ARG SHELL="zsh zoxide vim git fzf lf eza"
ARG TEXT="ripgrep bat fd jq yq rsync"
ARG MONITOR="btop ncdu lsof strace"
ARG NET_L2L3="ipcalc ethtool"
ARG NET_L4="bind-tools iputils iproute2 net-tools mtr inetutils-telnet whois conntrack-tools@testing gping@testing"
ARG NET_ANALYSIS="tcpdump ngrep@testing iftop@testing"
ARG NET_SECURITY="nmap nmap-scripts netcat-openbsd socat openssl"
ARG NET_PERF="iperf3 wrk@testing hping3@testing"
ARG PROTOCOL="curl httpie grpcurl@testing"

# install observer packages
SHELL ["/bin/sh", "-eo", "pipefail", "-c"]
RUN printf "@%s https://dl-cdn.alpinelinux.org/alpine/edge/%s\n" testing testing edge main >> /etc/apk/repositories && \
    apk add --update ${CORE} ${SHELL} ${TEXT} ${MONITOR} \
    ${NET_L2L3} ${NET_L4} ${NET_ANALYSIS} ${NET_SECURITY} ${NET_PERF} ${PROTOCOL}
# install eza theme, git-delta package, and colorize observer-banner
SHELL ["/bin/zsh", "-eo", "pipefail", "-c"]
RUN mkdir -p ~/{.zshrc.d,.config/{lf,eza}} && sed -i "s|#||g;1s|^|%F{#C0CAF5}|;\$s|$|%f|" /etc/observer/banner.braille && \
    curl -sSo ~/.config/eza/theme.yml https://raw.githubusercontent.com/eza-community/eza-themes/main/themes/tokyonight.yml && \
    repo=dandavison/delta; ver=$(curl -s https://api.github.com/repos/$repo/releases/latest | jq -r .tag_name) && \
    curl -Ls https://github.com/$repo/releases/download/$ver/delta-$ver-x86_64-unknown-linux-musl.tar.gz | \
    tar xz -C /usr/local/bin --strip=1 --wildcards '*delta' && rm -rf /bin/sh /var/cache/apk/* && \
    printf '%s\n' '#!/bin/busybox sh' 'exec /bin/zsh "$@"' | install -m 755 /dev/stdin /bin/sh

# 🎨 Configuration Files
COPY <<'EOF' /root/.config/lf/lfrc
set previewer bat --style=numbers,changes --color=always
map i $bat $f
EOF

COPY <<'EOF' /root/.zshrc
# --- Autoload ---
autoload -Uz colors compinit edit-command-line && colors
zle -N edit-command-line

# --- Load Modular Config ---
for config (~/.zshrc.d/*.zsh(N)) source $config

# --- Options ---
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY AUTO_CD PROMPT_SUBST

# --- Completion ---
fpath+=/usr/share/zsh/site-functions
[[ -f ~/.zcompdump && ~/.zshrc -ot ~/.zcompdump ]] && compinit -C || compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# --- Keybindings ---
bindkey -v
export KEYTIMEOUT=1
bindkey -M viins '^e' edit-command-line
bindkey -M vicmd '^e' edit-command-line
bindkey -v '^?' backward-delete-char
bindkey -s '^O' 'lfn\n'

# --- Productivity ---
(( $+commands[fzf] ))    && source <(fzf --zsh)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# --- Banner & Prompt ---
observer-banner && print -rP "%F{#C0CAF5}💡 Type 'h' or 'help' for observer's manual%f"
PROMPT='%F{white}[%D{%H:%M:%S %Z}] %B%F{cyan}🧬 $(hostname -i) %F{blue}%~ %F{green}➜ %f%b'
EOF

# 3. Functions Module
COPY <<'EOF' /root/.zshrc.d/functions.zsh
# LF file manager with CD on exit
lfn() {
  local t=$(mktemp); command lf -last-dir-path=$t "$@"
  [[ -f $t ]] && { local d=$(<$t); rm $t; [[ -d $d && $d != $PWD ]] && cd $d }
}
EOF

COPY <<'EOF' /root/.zshrc.d/aliases-core.zsh
# Help
alias h="bat -p /etc/observer/MANUAL.md" help="bat -p /etc/observer/MANUAL.md"

# Observer Banner
alias observer-banner='print -rP "$(< /etc/observer/banner.braille)"'

# Navigation
alias ..="cd .." ...="cd ../.." ....="cd ../../.." lf="lfn"

# Modern ls replacement
alias ls="eza" ll="eza -alF" la="eza -a" tree="eza --tree"

# Search
alias grep="grep --color=auto" rg="rg --pretty"

# Disk usage
alias df="df -h" du="du -h" free="free -h"

# Utilities
alias untar="tar -xvf" hist="history | tail -n 20" top="btop"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
EOF

COPY <<'EOF' /root/.zshrc.d/aliases-network.zsh
# Connection inspection
alias ports="netstat -tulpn" connections="ss -tunapl"
alias listen="lsof -iTCP -sTCP:LISTEN -n -P 2>/dev/null || ss -tlnp"
alias established="lsof -iTCP -sTCP:ESTABLISHED -n -P 2>/dev/null || ss -tnp"

# Network configuration
alias routes="ip route show" arp="ip neigh show" interfaces="ip -br addr show"
alias myip="curl -s ifconfig.me/ip 2>/dev/null || echo 'offline'"

# Network testing
alias pingg="ping -c 4 1.1.1.1" trace="mtr -z"
alias webtest="curl -o /dev/null -s -w 'HTTP: %{http_code}\nTime: %{time_total}s\n'"

# Packet analysis
alias sniff="tcpdump -i any" ngrep="ngrep -q" bandwidth="iftop"

# DNS & subnets
alias dns="dig +short" dnsall="dig +noall +answer"
EOF

COPY <<'EOF' /root/.zshrc.d/aliases-web.zsh
# HTTP shortcuts
alias http="curl -I" https="curl -I -k" curljson="curl -H 'Content-Type: application/json'"

# SSL/TLS inspection
alias sslcheck="openssl s_client -connect" certinfo="openssl s_client -showcerts -connect"
alias cert="openssl x509 -text -noout -in"
EOF

COPY <<'EOF' /root/.gitconfig
[core]
  pager = delta
[interactive]
  diffFilter = delta --color-only
[delta]
  navigate = true
  light = false
  side-by-side = true
  line-numbers = true
[merge]
  conflictstyle = diff3
[diff]
  colorMoved = default
EOF

# 📖 Copy Manual
COPY MANUAL.md /etc/observer/MANUAL.md

# 🌍 Environment
ENV TZ=UTC SHELL=/bin/zsh EDITOR=vim TERM=xterm-256color LANG=C.UTF-8 LC_ALL=C.UTF-8

# 🏠 Configuration
WORKDIR /root
STOPSIGNAL SIGTERM

# 🚀 Entrypoint
ENTRYPOINT ["/bin/zsh", "-c", "[[ -t 0 ]] && exec /bin/zsh || exec /bin/sleep infinity"]
