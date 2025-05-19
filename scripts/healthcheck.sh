#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <hostname>"
  exit 1
fi

healthcheck() {
  if curl --no-progress-meter --connect-timeout 10 --max-time 30 --fail -H "Host: localhost" "$1:8000"; then
    echo "Health check succeeded for $1:8000"
    return 0
  else
    echo "Health check failed for $1:8000"
    return 1
  fi
}

# Run health check once every second for up to 90 seconds
for _ in $(seq 1 90); do
  if healthcheck "$1"; then
    # If health check succeeds, exit the loop
    break
  fi
  # If health check fails, wait 1 second before retrying
  sleep 1
done

# If after 90 seconds we haven't broken out of the loop, the check failed
if [ $? -ne 0 ]; then
  echo "Health check failed after 90 seconds"
  exit 1
fi

