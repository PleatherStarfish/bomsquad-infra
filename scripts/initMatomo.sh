# create a file matomo/db.env
#
# MARIADB_PASSWORD=abcxyz
# MARIADB_ROOT_PASSWORD=abcxyz
# MATOMO_DATABASE_PASSWORD=abcxyz
# MYSQL_DATABASE=matomo
# MARIADB_DATABASE=matomo
# MYSQL_USER=matomo
# MARIADB_USER=matomo
# MATOMO_DATABASE_ADAPTER=mysql
# MATOMO_DATABASE_TABLES_PREFIX=matomo_
# MATOMO_DATABASE_USERNAME=matomo
# MATOMO_DATABASE_DBNAME=matomo
# MARIADB_AUTO_UPGRADE=1
# MARIADB_INITDB_SKIP_TZINFO=1

docker compose up -d 

# ssh tunnel 
ssh -L 8080:localhost:8080 devops@104.131.175.186

# navigate to http://localhost:8080 and go through web setup

docker compose down 

docker compose -f docker-compose.live.yaml up -d

# possible add/edit `data/matomo/config/config.ini.php`:
#
#trusted_hosts[] = "matomo.bom-squad.com"
#force_ssl = 1
#assume_secure_protocol = 1

