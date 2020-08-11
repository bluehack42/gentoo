#!/bin/bash

#ntpd -gq
TARGET_DISK=/dev/$(lsblk -d -n | grep disk | egrep -v 'sda|sdb|sdd' | awk '{print $1}')
echo -n "test" | cryptsetup luksOpen $(fdisk -l $TARGET_DISK | grep Linux | awk '{print $1;}')  lvm
rc-service lvm start
mount /dev/mapper/vg0-root /mnt/gentoo
mount -t proc none /mnt/gentoo/proc
mount -t sysfs none /mnt/gentoo/sys
mount -o bind /dev /mnt/gentoo/dev
mount -o bind /dev/pts /mnt/gentoo/dev/pts
mount --bind /run/lvm /mnt/gentoo/run/lvm
mount /dev/sda2 /mnt/gentoo/boot
