install gentoolkit for ansible module portage

```emerge --ask app-portage/gentoolkit```

check for missing kernel modules:
net-wireless/bluez-5.68
 *   CONFIG_CRYPTO_SHA1:	 is not set when it should be.
 *   CONFIG_KEY_DH_OPERATIONS:	 is not set when it should be.
