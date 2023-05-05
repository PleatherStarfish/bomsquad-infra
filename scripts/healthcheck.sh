#!/usr/bin/env bash
set -e

healthcheck() {

  # backend
  curl --no-progress-meter --connect-timeout 0.5 --fail "$1:8000"

  # frontend
  # curl --no-progress-meter --connect-timeout 0.5 --fail "$2:3000"
}

# Run once every 1s upto 90s
for _ in $(seq 1 90)
do
  if healthcheck "$1" > /dev/null 2> /dev/null; then
    break
  else
    sleep 1
  fi
done

# Final attempted, if this fails it fails the script and the deploy should fail
healthcheck "$1" 
