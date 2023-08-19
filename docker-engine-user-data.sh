#!/bin/bash

sudo apt update
sudo apt install openjdk-11-jdk -y
sudo apt install maven -y
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install jenkins -y

## installing docker engine 

sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo docker run hello-world

## add jenkins user to the group docker
id jenkins
usermod -a -G docker jenkins 
id jenkins

## install pass, rng-tools(for pass), aws-cli
sudo apt-get install awscli -y

#### run this in the terminal of the jenkins server 
# sudo rngd -r /dev/urandom
# sudo apt-get install rng-tools pass -y
# gpg --full-generate-key  ## leave everything as default and enter name, email, new passphrase
# mkdir ~/bin && cd ~/bin
# echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
# wget https://github.com/docker/docker-credential-helpers/releases/download/v0.7.0/docker-credential-pass-v0.7.0.linux-amd64
# chmod a+x docker-credential-pass-v0.7.0.linux-amd64
# sudo cp docker-credential-pass-v0.7.0.linux-amd64 /usr/local/bin  ## must be root to do this
# mkdir ~/.docker
# gpg --list-secret-keys ## copy the gpg key ID under sec after [SC]
# pass init {gpg key ID}
# pass insert docker-credential-helpers/docker-pass-initialized-check  ## enter new passphrase
# sudo vi ~/.docker/config.json

## reboot server
reboot 
