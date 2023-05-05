adduser devops 
passwd devops # set a password
usermod -a -G sudo devops

su devops
mkdir -p ~devops/.ssh/
echo 'your personal ssh pub goes key here (so you can access this user :) ) ' >  ~devops/.ssh/authorized_keys

sudo chmod 600 ~devops/.ssh/authorized_keys
sudo chown -R devops:devops ~devops/.ssh/

ssh-keygen -t ed25519
# Okay we generated the key, now we need to add this ~/.ssh/id_rsa.pub key to our application repo so  our node can clone down the application repo

mkdir -p ~devops/app/{production,dev}/

cd ~devops/app/
git clone git@github.com:PleatherStarfish/bomsquad-infra.git .
git checkout deploy/dev

cd ~devops/production
git clone git@github.com:PleatherStarfish/bomsquad-infra.git .
git checkout deploy/production
