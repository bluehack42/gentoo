#!/bin/bash

while ! ping -c 1 -W 1 1.1.1.1; do
  echo "Wait for network"
  sleep 1
done

git clone https://github.com/bluehack42/gentoo.git
ansible-playbook ~/gentoo/system/settings.yml
ansible-playbook ~/gentoo/package/gentoo-package.yml
ansible-playbook ~/gentoo/system/afterpackage.yml
ansible-playbook ~/gentoo/user/settings.yml
