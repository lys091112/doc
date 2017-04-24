#!/bin/bash


#参照官方文档，对原有的docker进行更新，参考链接：https://docs.docker.com/engine/installation/linux/ubuntu/#install-from-a-package


sudo apt-get upgrade

#Install packages to allow apt to use a repository over HTTPS
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

#Add Docker’s official GPG key using your customer Docker EE repository URL:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#apt-key fingerprint 0EBFCD88
sudo apt-key fingerprint 0EBFCD88

#Use the following command to set up the stable repository, replacing <DOCKER-EE-URL> with the URL you noted down in the prerequisites.
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

#Update the apt package index
sudo apt-get upgrade

#install the latest version of Docker
sudo apt-get install docker-ce
