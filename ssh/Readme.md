# Sign SSH key

### generate CA
```Shell
ssh-keygen -C CA -f ca
```

### sign key
```Shell
ssh-keygen -s ca -I "ID" -n "username" -V +1d id_rsa.pub
```
