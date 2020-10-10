### python
pip install -r requirements.txt --user

### Steps for GPG key yubikey

### generate key

```shell
gpg --full-generate-key
```


```shel
blue@ecto1 ~> gpg --full-generate-key
gpg (GnuPG) 2.2.20; Copyright (C) 2020 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
  (14) Existing key from card
Your selection? 1
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 
Key does not expire at all
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.

Real name: Patrik Marxer
Email address: patrik.marxer@sourcecode.li
Comment: 
You selected this USER-ID:
    "Patrik Marxer <patrik.marxer@sourcecode.li>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: key 18F15128C12946DF marked as ultimately trusted
gpg: revocation certificate stored as '/home/blue/.gnupg/openpgp-revocs.d/F7BCEF9FDE349F601016B09518F15128C12946DF.rev'
public and secret key created and signed.

pub   rsa4096 2020-08-27 [SC]
      F7BCEF9FDE349F601016B09518F15128C12946DF
uid                      Patrik Marxer <patrik.marxer@sourcecode.li>
sub   rsa4096 2020-08-27 [E]

blue@ecto1 ~> 
```

### export keys
```
blue@ecto1 ~> gpg --export-secret-keys --armor F7BCEF9FDE349F601016B09518F15128C12946DF > patrik.marxer_sourcecode.li.key 
blue@ecto1 ~> gpg --export --armor F7BCEF9FDE349F601016B09518F15128C12946DF > patrik.marxer_sourcecode.li.key.pub 
```

### reset yubikey
```shell
blue@ecto1 ~> ykman openpgp reset
WARNING! This will delete all stored OpenPGP keys and data and restore factory settings? [y/N]: y
Resetting OpenPGP data, don't remove your YubiKey...
Success! All data has been cleared and default PINs are set.
PIN:         123456
Reset code:  NOT SET
Admin PIN:   12345678
```

### generate key and move to card
```shell
blue@ecto1 ~/g/sshKey> gpg --edit-key --expert F7BCEF9FDE349F601016B09518F15128C12946DF
gpg (GnuPG) 2.2.20; Copyright (C) 2020 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  rsa4096/18F15128C12946DF
     created: 2020-08-27  expires: never       usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa4096/6E6B6987FC3CCD52
     created: 2020-08-27  expires: never       usage: E   
[ultimate] (1). Patrik Marxer <patrik.marxer@sourcecode.li>

gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
  (14) Existing key from card
Your selection? 8

Possible actions for a RSA key: Sign Encrypt Authenticate 
Current allowed actions: Sign Encrypt 

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? s

Possible actions for a RSA key: Sign Encrypt Authenticate 
Current allowed actions: Encrypt 

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? e

Possible actions for a RSA key: Sign Encrypt Authenticate 
Current allowed actions: 

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? a

Possible actions for a RSA key: Sign Encrypt Authenticate 
Current allowed actions: Authenticate 

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? Q
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 
Requested keysize is 2048 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 1y
Key expires at Fri 27 Aug 2021 23:09:32 CEST
Is this correct? (y/N) y
Really create? (y/N) y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  rsa4096/18F15128C12946DF
     created: 2020-08-27  expires: never       usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa4096/6E6B6987FC3CCD52
     created: 2020-08-27  expires: never       usage: E   
ssb  rsa2048/676D9FFEEDC9CE58
     created: 2020-08-27  expires: 2021-08-27  usage: A   
[ultimate] (1). Patrik Marxer <patrik.marxer@sourcecode.li>

gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
  (14) Existing key from card
Your selection? 8

Possible actions for a RSA key: Sign Encrypt Authenticate 
Current allowed actions: Sign Encrypt 

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? s

Possible actions for a RSA key: Sign Encrypt Authenticate 
Current allowed actions: Encrypt 

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? Q
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 
Requested keysize is 2048 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 1y
Key expires at Fri 27 Aug 2021 23:09:57 CEST
Is this correct? (y/N) y
Really create? (y/N) y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  rsa4096/18F15128C12946DF
     created: 2020-08-27  expires: never       usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa4096/6E6B6987FC3CCD52
     created: 2020-08-27  expires: never       usage: E   
ssb  rsa2048/676D9FFEEDC9CE58
     created: 2020-08-27  expires: 2021-08-27  usage: A   
ssb  rsa2048/A06FEE003F803D87
     created: 2020-08-27  expires: 2021-08-27  usage: E   
[ultimate] (1). Patrik Marxer <patrik.marxer@sourcecode.li>

gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
  (14) Existing key from card
Your selection? 8

Possible actions for a RSA key: Sign Encrypt Authenticate 
Current allowed actions: Sign Encrypt 

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? e

Possible actions for a RSA key: Sign Encrypt Authenticate 
Current allowed actions: Sign 

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? Q
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 
Requested keysize is 2048 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 1y
Key expires at Fri 27 Aug 2021 23:10:23 CEST
Is this correct? (y/N) y
Really create? (y/N) y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  rsa4096/18F15128C12946DF
     created: 2020-08-27  expires: never       usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa4096/6E6B6987FC3CCD52
     created: 2020-08-27  expires: never       usage: E   
ssb  rsa2048/676D9FFEEDC9CE58
     created: 2020-08-27  expires: 2021-08-27  usage: A   
ssb  rsa2048/A06FEE003F803D87
     created: 2020-08-27  expires: 2021-08-27  usage: E   
ssb  rsa2048/698A5B4465929774
     created: 2020-08-27  expires: 2021-08-27  usage: S   
[ultimate] (1). Patrik Marxer <patrik.marxer@sourcecode.li>

gpg> key 4

sec  rsa4096/18F15128C12946DF
     created: 2020-08-27  expires: never       usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa4096/6E6B6987FC3CCD52
     created: 2020-08-27  expires: never       usage: E   
ssb  rsa2048/676D9FFEEDC9CE58
     created: 2020-08-27  expires: 2021-08-27  usage: A   
ssb  rsa2048/A06FEE003F803D87
     created: 2020-08-27  expires: 2021-08-27  usage: E   
ssb* rsa2048/698A5B4465929774
     created: 2020-08-27  expires: 2021-08-27  usage: S   
[ultimate] (1). Patrik Marxer <patrik.marxer@sourcecode.li>

gpg> keytocard
Please select where to store the key:
   (1) Signature key
   (3) Authentication key
Your selection? 1

sec  rsa4096/18F15128C12946DF
     created: 2020-08-27  expires: never       usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa4096/6E6B6987FC3CCD52
     created: 2020-08-27  expires: never       usage: E   
ssb  rsa2048/676D9FFEEDC9CE58
     created: 2020-08-27  expires: 2021-08-27  usage: A   
ssb  rsa2048/A06FEE003F803D87
     created: 2020-08-27  expires: 2021-08-27  usage: E   
ssb* rsa2048/698A5B4465929774
     created: 2020-08-27  expires: 2021-08-27  usage: S   
[ultimate] (1). Patrik Marxer <patrik.marxer@sourcecode.li>

gpg> key 3

sec  rsa4096/18F15128C12946DF
     created: 2020-08-27  expires: never       usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa4096/6E6B6987FC3CCD52
     created: 2020-08-27  expires: never       usage: E   
ssb  rsa2048/676D9FFEEDC9CE58
     created: 2020-08-27  expires: 2021-08-27  usage: A   
ssb* rsa2048/A06FEE003F803D87
     created: 2020-08-27  expires: 2021-08-27  usage: E   
ssb* rsa2048/698A5B4465929774
     created: 2020-08-27  expires: 2021-08-27  usage: S   
[ultimate] (1). Patrik Marxer <patrik.marxer@sourcecode.li>

gpg> key 4

sec  rsa4096/18F15128C12946DF
     created: 2020-08-27  expires: never       usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa4096/6E6B6987FC3CCD52
     created: 2020-08-27  expires: never       usage: E   
ssb  rsa2048/676D9FFEEDC9CE58
     created: 2020-08-27  expires: 2021-08-27  usage: A   
ssb* rsa2048/A06FEE003F803D87
     created: 2020-08-27  expires: 2021-08-27  usage: E   
ssb  rsa2048/698A5B4465929774
     created: 2020-08-27  expires: 2021-08-27  usage: S   
[ultimate] (1). Patrik Marxer <patrik.marxer@sourcecode.li>

gpg> keytocard
Please select where to store the key:
   (2) Encryption key
Your selection? 2

sec  rsa4096/18F15128C12946DF
     created: 2020-08-27  expires: never       usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa4096/6E6B6987FC3CCD52
     created: 2020-08-27  expires: never       usage: E   
ssb  rsa2048/676D9FFEEDC9CE58
     created: 2020-08-27  expires: 2021-08-27  usage: A   
ssb* rsa2048/A06FEE003F803D87
     created: 2020-08-27  expires: 2021-08-27  usage: E   
ssb  rsa2048/698A5B4465929774
     created: 2020-08-27  expires: 2021-08-27  usage: S   
[ultimate] (1). Patrik Marxer <patrik.marxer@sourcecode.li>

gpg> key 2

sec  rsa4096/18F15128C12946DF
     created: 2020-08-27  expires: never       usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa4096/6E6B6987FC3CCD52
     created: 2020-08-27  expires: never       usage: E   
ssb* rsa2048/676D9FFEEDC9CE58
     created: 2020-08-27  expires: 2021-08-27  usage: A   
ssb* rsa2048/A06FEE003F803D87
     created: 2020-08-27  expires: 2021-08-27  usage: E   
ssb  rsa2048/698A5B4465929774
     created: 2020-08-27  expires: 2021-08-27  usage: S   
[ultimate] (1). Patrik Marxer <patrik.marxer@sourcecode.li>

gpg> key 3

sec  rsa4096/18F15128C12946DF
     created: 2020-08-27  expires: never       usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa4096/6E6B6987FC3CCD52
     created: 2020-08-27  expires: never       usage: E   
ssb* rsa2048/676D9FFEEDC9CE58
     created: 2020-08-27  expires: 2021-08-27  usage: A   
ssb  rsa2048/A06FEE003F803D87
     created: 2020-08-27  expires: 2021-08-27  usage: E   
ssb  rsa2048/698A5B4465929774
     created: 2020-08-27  expires: 2021-08-27  usage: S   
[ultimate] (1). Patrik Marxer <patrik.marxer@sourcecode.li>

gpg> keytocard
Please select where to store the key:
   (3) Authentication key
Your selection? 3

sec  rsa4096/18F15128C12946DF
     created: 2020-08-27  expires: never       usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa4096/6E6B6987FC3CCD52
     created: 2020-08-27  expires: never       usage: E   
ssb* rsa2048/676D9FFEEDC9CE58
     created: 2020-08-27  expires: 2021-08-27  usage: A   
ssb  rsa2048/A06FEE003F803D87
     created: 2020-08-27  expires: 2021-08-27  usage: E   
ssb  rsa2048/698A5B4465929774
     created: 2020-08-27  expires: 2021-08-27  usage: S   
[ultimate] (1). Patrik Marxer <patrik.marxer@sourcecode.li>

gpg> save
```

### card status
```shell
blue@ecto1 ~/g/sshKey> gpg --card-status
Reader ...........: 1050:0116:X:0
Application ID ...: D2760001240102000006038154350000
Application type .: OpenPGP
Version ..........: 2.0
Manufacturer .....: Yubico
Serial number ....: 03815435
Name of cardholder: [not set]
Language prefs ...: [not set]
Salutation .......: 
URL of public key : [not set]
Login data .......: [not set]
Signature PIN ....: forced
Key attributes ...: rsa2048 rsa2048 rsa2048
Max. PIN lengths .: 127 127 127
PIN retry counter : 3 3 3
Signature counter : 0
Signature key ....: CD9F 976B 0105 2B44 4A93  D3E7 698A 5B44 6592 9774
      created ....: 2020-08-27 21:10:06
Encryption key....: EEDC 69FD CC23 B132 CC91  B389 A06F EE00 3F80 3D87
      created ....: 2020-08-27 21:09:41
Authentication key: 66B2 838D 1E11 2C0A 1F57  FADA 676D 9FFE EDC9 CE58
      created ....: 2020-08-27 21:09:13
General key info..: sub  rsa2048/698A5B4465929774 2020-08-27 Patrik Marxer <patrik.marxer@sourcecode.li>
sec   rsa4096/18F15128C12946DF  created: 2020-08-27  expires: never     
ssb   rsa4096/6E6B6987FC3CCD52  created: 2020-08-27  expires: never     
ssb>  rsa2048/676D9FFEEDC9CE58  created: 2020-08-27  expires: 2021-08-27
                                card-no: 0006 03815435
ssb>  rsa2048/A06FEE003F803D87  created: 2020-08-27  expires: 2021-08-27
                                card-no: 0006 03815435
ssb>  rsa2048/698A5B4465929774  created: 2020-08-27  expires: 2021-08-27
                                card-no: 0006 03815435
```


