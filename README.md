# bomsquad-infra

This repo is responsible for the deployment functionality, as well as the setup of the application and related services.

## Setup

The setup is roughly documented here: [./scripts/init.sh](./scripts/init.sh)

Open the file and run each step one by one. It would be ideal for this script to be fully automated, however there are some manual steps to run (like setting up the DNS records), and it has not been tested as whole end to end. However it is very close to being fully automated.

## Matomo setup

When setting up matomo, make sure it's accessible only to yourself (by port forwarding). And only after setup has been completed to make it publicly accessible.

The setup is roughly documented here: [./scripts/initMatomo.sh](./scripts/initMatomo.sh)

## Letsencrypt setup 

The setup is roughly documented here: [./scripts/initSsl.sh](./scripts/initSsl.sh)

## Database backup and restore

The setup is roughly documented here: [./scripts/db_dump.sh](./scripts/db_dump.sh)
