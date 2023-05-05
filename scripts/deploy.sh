#!/usr/bin/env bash
set -eou
set -x

DEPLOY_DIR=$1

cd "$DEPLOY_DIR"

git pull

echo "-- DOCKER BUILD --"

sudo docker compose \
  -f docker-compose.live-environment.yml \
  --env-file .env.dev \
  build

echo "-- DOCKER UP --"

sudo docker compose \
  -f docker-compose.live-environment.yml \
  --env-file .env.dev \
  up -d 

backendContainer=$(sudo docker compose \
  -f docker-compose.live-environment.yml \
  --env-file .env.dev \
  ps -q backend)

# frontendContainer=$(sudo docker compose \
#   -f docker-compose.live-environment.yml \
#   --env-file .env.dev \
#   ps -q frontend)

# Basic healthcheck

backendContainerIP=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$backendContainer")
# frontendContainerIP=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$frontendContainer")

if ! /home/devops/infra/scripts/healthcheck.sh "$backendContainerIP"; then
  echo "-- DOCKER LOGS BACKEND --"

  sudo docker compose \
    -f docker-compose.live-environment.yml \
    --env-file .env.dev \
    logs backend

  #echo "-- DOCKER LOGS FRONTEND --"

  #sudo docker compose \
    #-f docker-compose.live-environment.yml \
    #--env-file .env.dev \
    #logs frontend

  echo "Healthchecks failed!!! See logs above"
  exit 1
fi

