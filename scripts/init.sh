GIT_REPO_REMOTE="git@github.com:chrissound/bomsquad.git"
GIT_REPO_REMOTE_INFRA="git@github.com:chrissound/bomsquad-infra.git"

# -1. Set hostname
sudo hostnamectl set-hostname bomsquad-production-and-dev

# 1. Setup devops user

# add user and add to sudo group
sudo useradd -m devops -s /bin/bash
sudo usermod -aG sudo devops

# Set it to not prompt for password for devops user when using sudo
echo "devops  ALL = NOPASSWD : ALL" | sudo tee /etc/sudoers.d/devops
sudo chmod 0440 /etc/sudoers.d/devops
sudo visudo -c && sudo visudo -c -f /etc/sudoers.d/devops || {
    echo "ERROR Invalid sudo file"
    sudo rm /etc/sudoers.d/devops 
    exit 1
}

# 2. Install docker

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 3. Add SSH access to devops user
mkdir -p ~devops/.ssh/
read -p "Enter your personal SSH public key that can be used to access the devops user: " ssh_key
echo "$ssh_key" >> ~devops/.ssh/authorized_keys

sudo chmod 600 ~devops/.ssh/authorized_keys
sudo chown -R devops:devops ~devops/.ssh/

# 4. Setup SSH key for devops user
sudo su devops 
ssh-keygen -t ed25519 # accept defaults

# 5. Ensure 
# Okay we generated the key, now we need to setup access to the application repo
# This can be done by adding the just generated public key `/home/devops/.ssh/id_ed25519.pub` to the github application repo (Deploy keys)
if ! git ls-remote "$GIT_REPO_REMOTE"; then
  echo "No access to git repo"
  exit 1
fi

# 6. Setup application
for env in dev production; do
    mkdir -p ~devops/app/$env
    cd ~devops/app/$env || exit 1
    git clone "$GIT_REPO_REMOTE" .
    git checkout deploy/$env
done

# 7. Setup infra repo
git clone "$GIT_REPO_REMOTE_INFRA" ~devops/infra


# 8. Setup infra nginx
cd ~devops/infra/nginx-proxy/
cp default.pressl.conf default.conf
sudo docker compose up -d 

~devops/infra/scripts/initSsl.sh

git checkout -- default.conf

sudo docker compose restart

# 9. You need to configure the DB potentially:
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

# 10. Create the .env file in ~/app/{dev,production}

# 11. Create devops SSH private key (private key will be held with github actions)
ssh-keygen -t ed25519 -f devops
echo "SSH_PRIV_KEY:"
cat devops | base64 -w 0
echo "SSH public key to .ssh/authorized_keys:"
cat devops.pub

# Setup `SSH_PRIV_KEY` secret in github actions in app repo (base64 encoded - `| base64 -w 0`)
# Copy the devops.pub to ~devops/.ssh/authorized_keys

# 12. Trigger a deploy from github actions
# This can be done by adding a new commit to `dev/deploy`
