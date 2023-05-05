rsync -av /home/chris/temp/wiptemp/796/repos/bomsquad \
  devops@134.209.65.8:/home/devops/app/dev/

cd /home/chris/temp/wiptemp/796
rsync -e "ssh -o 'ControlPath=$HOME/.ssh/ctl/%L-%r@%h:%p'" --relative -av $(git ls-files) \
  devops@134.209.65.8:/home/devops/infra/
