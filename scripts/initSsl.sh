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


sudo cp nginx-proxy/nginx-daily-reload.service /etc/systemd/system/nginx-daily-reload.service
sudo cp nginx-proxy/nginx-daily-reload.timer /etc/systemd/system/nginx-daily-reload.timer

sudo systemctl daemon-reload
sudo systemctl enable nginx-daily-reload.timer
sudo systemctl start nginx-daily-reload.timer
