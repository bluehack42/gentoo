#!/bin/bash

while ! ping -c 1 -W 1 1.1.1.1; do
  echo "Wait for network"
  sleep 1
done

git clone https://github.com/bluehack42/gentoo.git 
cd gentoo/package
ansible-playbook gentoo-package.yml
ansible-playbook chezmoi.yml
