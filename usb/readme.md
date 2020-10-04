# generate usb stick

```shell
emerge --ask sys-fs/dosfstools
```

## format stick
```shell
mkfs.fat -F 16 /dev/sdc1
```

Hex code (type L to list all codes): b
mkfs.fat /dev/sdb1

emerge --ask --verbose sys-boot/syslinux

mkdir /mnt/cdrom
mount /home/blue/Downloads/

mount /home/blue/Downloads/install-amd64-minimal-20200909T214504Z.iso /mnt/cdrom/
mount /dev/sdb1 /mnt/usb/
cp -r /mnt/cdrom/* /mnt/usb
mv /mnt/usb/isolinux/* /mnt/usb
mv /mnt/usb/isolinux.cfg /mnt/usb/syslinux.cfg
rm -rf /mnt/usb/isolinux*
mv /mnt/usb/memtest86 /mnt/usb/memtest
umount /mnt/cdrom/
sed -i -e "s:cdroot:cdroot slowusb:" -e "s:kernel memtest86:kernel memtest:" /mnt/usb/syslinux.cfg
umount /mnt/usb
syslinux /dev/sdb1 


mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
