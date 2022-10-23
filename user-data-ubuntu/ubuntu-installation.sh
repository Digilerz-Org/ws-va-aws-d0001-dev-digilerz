#!/bin/bash

sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo usermod -aG root ${USER}
sudo su - ${USER}
sudo chown -R ${USER} /etc/ansible
sudo echo 'localhost ansible_connection=local' >> /etc/ansible/hosts