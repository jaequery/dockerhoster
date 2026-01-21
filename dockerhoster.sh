#!/usr/bin/env bash
# DockerHoster – one-command Docker vhost hosting via nginx-proxy
# Supports: Ubuntu 22.04 LTS or later (latest LTS recommended)
# Commands: start | stop | restart | status

set -euo pipefail

ACTION=${1:-start}

PROXY_NAME=nginx-proxy
NETWORK=proxy-network
NGINX_CONFIG_DIR=/opt/dockerhoster/nginx/conf.d
CONFIG_FILE=$NGINX_CONFIG_DIR/client_max_body_size.conf
DOCKER_IMAGE=jwilder/nginx-proxy

log() { echo "▶ $1"; }
die() { echo "❌ $1"; exit 1; }

# ---------------------------
# Preconditions
# ---------------------------
require_root() {
  [[ $EUID -eq 0 ]] || die "Run as root"
}

require_systemd() {
  command -v systemctl >/dev/null 2>&1 || \
    die "systemd not found. Ubuntu 16.04+ required."
}

# ---------------------------
# Docker
# ---------------------------
install_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    log "Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
  fi
}

# ---------------------------
# Host cleanup
# ---------------------------
stop_host_webservers() {
  for svc in nginx apache2; do
    if systemctl is-active --quiet "$svc"; then
      log "Stopping host $svc"
      systemctl stop "$svc"
      systemctl disable "$svc" || true
    fi
  done
}

# ---------------------------
# Docker network
# ---------------------------
ensure_network() {
  if ! docker network ls --format '{{.Name}}' | grep -q "^$NETWORK$"; then
    log "Creating Docker network: $NETWORK"
    docker network create "$NETWORK"
  fi
}

# ---------------------------
# Nginx config
# ---------------------------
write_nginx_config() {
  mkdir -p "$NGINX_CONFIG_DIR"

  cat > "$CONFIG_FILE" << 'EOF'
# Upload limits
client_max_body_size 1000M;
client_body_buffer_size 1000M;

# Timeouts for large uploads
proxy_connect_timeout 600;
proxy_send_timeout 600;
proxy_read_timeout 600;
send_timeout 600;
EOF
}

# ---------------------------
# Container helpers
# ---------------------------
container_exists() {
  docker ps -a --format '{{.Names}}' | grep -q "^$PROXY_NAME$"
}

container_running() {
  docker ps --format '{{.Names}}' | grep -q "^$PROXY_NAME$"
}

# ---------------------------
# Actions
# ---------------------------
start_proxy() {
  require_root
  require_systemd
  install_docker
  stop_host_webservers
  ensure_network
  write_nginx_config

  if container_running; then
    log "nginx-proxy already running"
    exit 0
  fi

  if container_exists; then
    log "Removing old nginx-proxy container"
    docker rm -f "$PROXY_NAME"
  fi

  log "Starting nginx-proxy..."
  docker run -d \
    --name "$PROXY_NAME" \
    --network "$NETWORK" \
    -p 80:80 \
    -p 443:443 \
    -v /var/run/docker.sock:/tmp/docker.sock:ro \
    -v "$CONFIG_FILE:/etc/nginx/conf.d/client_max_body_size.conf:ro" \
    --restart always \
    "$DOCKER_IMAGE"

  sleep 2
  container_running || die "nginx-proxy failed to start"

  log "nginx-proxy started successfully"
}

stop_proxy() {
  if container_exists; then
    log "Stopping nginx-proxy"
    docker rm -f "$PROXY_NAME"
  else
    log "nginx-proxy not running"
  fi
}

status_proxy() {
  if container_running; then
    docker ps | grep "$PROXY_NAME"
  else
    echo "nginx-proxy stopped"
  fi
}

# ---------------------------
# Entry
# ---------------------------
case "$ACTION" in
  start)   start_proxy ;;
  stop)    stop_proxy ;;
  restart) stop_proxy; start_proxy ;;
  status)  status_proxy ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac

