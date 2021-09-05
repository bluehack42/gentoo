#!/bin/bash

set -e

ssh-keygen -s ca $(gopass show vps/ca > ca; chmod 600 ca) -I $USER -n $USER -V +1d ~/.ssh/id_rsa.pub
rm ca
