sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

sudo chown -R 101:101 /var/www/html

# first
sudo certbot certonly \
  -d dev.bom-squad.com \
  --webroot --webroot-path /var/www/html \
  --agree-tos 

# after
sudo certbot certonly \
  -d bom-squad.com \
  -d dev.bom-squad.com \
  -d matomo.bom-squad.com \
  --webroot --webroot-path /var/www/html \
  --agree-tos 
