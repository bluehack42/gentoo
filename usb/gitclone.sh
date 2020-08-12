#!/bin/bash

sleep 20
git clone https://github.com/bluehack42/gentoo.git 
cd gentoo/package
ansible-playbook gentoo-package.yml
ansible-playbook chezmoi.yml
