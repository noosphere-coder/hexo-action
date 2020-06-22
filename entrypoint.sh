#!/bin/sh

set -e

# setup ssh-private-key
mkdir -p /root/.ssh/
echo "$INPUT_DEPLOY_KEY" > /root/.ssh/id_rsa
echo "$INPUT_DEPLOY_KEY_CODING" > /root/.ssh/coding_rsa

chmod 600 /root/.ssh/id_rsa
chmod 600 /root/.ssh/coding_rsa

ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
ssh-keyscan -t rsa e.coding.net >> /root/.ssh/known_hosts

cat << EOF > /root/.ssh/config
Host github.com  
    HostName github.com  
    PreferredAuthentications publickey  
    IdentityFile /root/.ssh/id_rsa

Host e.coding.net  
    HostName e.coding.net  
    PreferredAuthentications publickey  
    IdentityFile /root/.ssh/coding_rsa 
EOF

chmod 600 /root/.ssh/config

# setup deploy git account
git config --global user.name "$INPUT_USER_NAME"
git config --global user.email "$INPUT_USER_EMAIL"

# install hexo env
npm install hexo-cli -g
npm install hexo-deployer-git --save

git clone https://github.com/$GITHUB_ACTOR/$GITHUB_ACTOR.github.io.git .deploy_git

# deployment
if [ "$INPUT_COMMIT_MSG" == "" ]
then
    hexo g -d
else
    hexo g -d -m "$INPUT_COMMIT_MSG"
fi

echo ::set-output name=notify::"Deploy complate."