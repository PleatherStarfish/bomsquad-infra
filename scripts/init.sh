# as root
adduser devops 
passwd devops # set a password
usermod -a -G sudo devops

# Add the following line to end of sudoers file using 'visudo'
# devops  ALL = NOPASSWD : ALL

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# as devops user `su devops`

mkdir -p ~devops/.ssh/
echo 'your personal ssh pub goes key here (so you can access this user :) ) ' >>  ~devops/.ssh/authorized_keys

sudo chmod 600 ~devops/.ssh/authorized_keys
sudo chown -R devops:devops ~devops/.ssh/

ssh-keygen -t ed25519

# Okay we generated the key, now we need to add this /home/devops/.ssh/id_ed25519.pub key to our application repo so our node can clone down the application repo

mkdir -p ~devops/app/{production,dev}/

cd ~devops/app/dev/
# git@github.com:PleatherStarfish/bomsquad.git .
git clone https://github.com/PleatherStarfish/bomsquad.git .
git checkout deploy/dev

cd ~devops/app/production
#git@github.com:PleatherStarfish/bomsquad.git .
git clone https://github.com/PleatherStarfish/bomsquad.git .
git checkout deploy/production

mkdir ~devops/infra
cd ~devops/infra/
git clone https://github.com/PleatherStarfish/bomsquad-infra.git .

cd ~devops/infra/nginx-proxy/
cp default.pressl.conf default.conf
sudo docker compose up -d 

/home/devops/infra/initSsl.sh

git checkout -- default.conf

sudo docker compose restart

# You need to configure the DB potentially:
#```
# GRANT USAGE ON SCHEMA public TO dev;
# GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO dev;
# GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO dev;
# GRANT ALL ON schema public TO dev;
#```
#
#```
# GRANT USAGE ON SCHEMA public TO production;
# GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO production;
# GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO production;
# GRANT ALL ON schema public TO production;
#```
