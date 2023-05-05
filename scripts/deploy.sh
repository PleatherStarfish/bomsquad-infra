#!/usr/bin/env bash
set -eou
set -x

DEPLOY_DIR=$1
COMMIT_SHA=$2

cd "$DEPLOY_DIR"

get fetch
git reset --hard "$COMMIT_SHA"

echo "-- DOCKER BUILD --"

sudo docker compose \
  -f docker-compose.live-environment.yml \
  --env-file .env \
  build

echo "-- DOCKER UP --"

sudo docker compose \
  -f docker-compose.live-environment.yml \
  --env-file .env \
  up -d 

backendContainer=$(sudo docker compose \
  -f docker-compose.live-environment.yml \
  --env-file .env \
  ps -q backend)

# frontendContainer=$(sudo docker compose \
#   -f docker-compose.live-environment.yml \
#   --env-file .env \
#   ps -q frontend)

# Basic healthcheck

backendContainerIP=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$backendContainer")
# frontendContainerIP=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$frontendContainer")

if ! /home/devops/infra/scripts/healthcheck.sh "$backendContainerIP"; then
  echo "-- DOCKER LOGS BACKEND --"

  sudo docker compose \
    -f docker-compose.live-environment.yml \
    --env-file .env \
    logs backend

  #echo "-- DOCKER LOGS FRONTEND --"

  #sudo docker compose \
    #-f docker-compose.live-environment.yml \
    #--env-file .env \
    #logs frontend

  echo "Healthchecks failed!!! See logs above"
  exit 1
fi

