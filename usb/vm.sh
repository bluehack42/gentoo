#!/bin/bash
sed -i '' '/192.168.1.100/d' $HOME/.ssh/known_hosts
ssh-keyscan -H 192.168.1.100 >> ~/.ssh/known_hosts
scp gentoo-install.sh root@192.168.1.100:/root
ssh root@192.168.1.100
