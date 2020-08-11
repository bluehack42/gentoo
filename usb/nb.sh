#!/bin/bash
sed -i '' '/192.168.178.179/d' $HOME/.ssh/known_hosts
ssh-keyscan -H 192.168.178.179 >> ~/.ssh/known_hosts
scp gentoo-install.sh root@192.168.178.179:/root
ssh root@192.168.178.179
