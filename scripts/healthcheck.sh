#!/usr/bin/env bash
set -e

healthcheck() {
  if curl --no-progress-meter --connect-timeout 10 --max-time 30 --fail "$1:8000"; then
    echo "Health check succeeded for $1:8000"
  else
    echo "Health check failed for $1:8000"
    exit 1
  fi
}

# Run health check once every second for up to 600 seconds (10 minutes)
for _ in $(seq 1 600); do
  if healthcheck "$1"; then
    break
  else
    sleep 1
  fi
done

# Final health check attempt; if this fails, the script will exit with a non-zero status
healthcheck "$1"
