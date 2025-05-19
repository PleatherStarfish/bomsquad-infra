# A docker container to run all the below commands
sudo docker run -it --rm --network host \
  -v "$(pwd)/backups:/backups" \
  --entrypoint /bin/bash \
  postgres:15 

# Backup production database example

pg_dump \
  -h bom-squad-db-2-do-user-13636487-0.b.db.ondigitalocean.com \
  -p 25060 \
  -U production \
  -d production \
  -F c \
  --no-owner \
  --no-acl \
  -f /backups/backup.production.$(date '+%H-%M-%S-%d-%m-%Y').dump

# Enter a psql console
psql \
    -h bom-squad-db-2-do-user-13636487-0.b.db.ondigitalocean.com \
    -p 25060 \
    -U doadmin \
    -d defaultdb

# Restore a previous backup from a filepath into `dev` database exmaple
pg_restore \
    -h bom-squad-db-2-do-user-13636487-0.b.db.ondigitalocean.com \
    -p 25060 \
    -U dev \
    -d dev \
    --no-owner \
    -v /backups/backup.production.17-07-25-24-02-2025.dump
