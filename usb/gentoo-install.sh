#!/bin/bash

set -e

GENTOO_RELEASES_URL=http://distfiles.gentoo.org/releases

GENTOO_ARCH=amd64
GENTOO_VARIANT=amd64

TARGET_DISK=$(lsblk -d -n -o path,model,type,vendor | grep disk | egrep -v 'rom|Trans-It Drive|sda|sdb|sdd'  | awk '{print $1}')

GRUB_PLATFORMS=pc

HARDWARE=$(dmidecode -s system-product-name)

# Creating partitions.
echo 'type=31' | sfdisk $TARGET_DISK -a

# format
# mkfs.vfat -F32 /dev/sda1

modprobe dm-crypt

# mount efi partition and create key
mkdir -p /mnt/boot
echo -e "UUID=$(blkid -s UUID -t PARTLABEL="EFI system partition" -o value)\t\t\t\t\t\t/mnt/boot\tvfat\t\tdefaults\t0 1" >> /etc/fstab
mount /mnt/boot
dd if=/dev/urandom of=/mnt/boot/keyfile bs=1024 count=4

echo "YES" | cryptsetup luksFormat -y -s 512 $(fdisk -l $TARGET_DISK | grep Linux | awk '{print $1;}') --key-file /mnt/boot/keyfile 
# echo -n "test" | cryptsetup luksFormat -y -s 512 $(fdisk -l $TARGET_DISK | grep Linux | awk '{print $1;}') -

# echo -n "test" | cryptsetup luksOpen $(fdisk -l $TARGET_DISK | grep Linux | awk '{print $1;}')  lvm
cryptsetup luksOpen $(fdisk -l $TARGET_DISK | grep Linux | awk '{print $1;}') --key-file /mnt/boot/keyfile lvm

umount /mnt/boot

# start lvm
rc-service lvm start

lvm pvcreate /dev/mapper/lvm

vgcreate vg0 /dev/mapper/lvm

lvcreate -L 10GiB -n swap vg0

lvcreate -l 100%FREE -n root vg0

mkfs.ext4 /dev/mapper/vg0-root

mount /dev/mapper/vg0-root /mnt/gentoo

mkswap /dev/mapper/vg0-swap
swapon /dev/mapper/vg0-swap

cd /mnt/gentoo

# Downloading stage3

STAGE3_PATH_URL=$GENTOO_RELEASES_URL/$GENTOO_ARCH/autobuilds/latest-stage3-$GENTOO_VARIANT.txt
STAGE3_PATH=$(curl -s $STAGE3_PATH_URL | grep -v "^#" | cut -d" " -f1)
STAGE3_URL=$GENTOO_RELEASES_URL/$GENTOO_ARCH/autobuilds/$STAGE3_PATH

wget $STAGE3_URL

# Extracting stage3.

tar xvpf $(basename $STAGE3_URL)

# Downloading portage.

PORTAGE_URL=http://distfiles.gentoo.org/snapshots/portage-latest.tar.xz
wget $PORTAGE_URL

# Extracting portage.

tar xvf $(basename $PORTAGE_URL) -C usr

#echo "### Installing kernel configuration..."

# Initializing portage

mkdir -p /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

# Copying network options
cp -v /etc/resolv.conf /mnt/gentoo/etc/

# Mounting proc/sys/dev/pts.
mount -t proc none /mnt/gentoo/proc
mount -t sysfs none /mnt/gentoo/sys
mount -o bind /dev /mnt/gentoo/dev
mount -o bind /dev/pts /mnt/gentoo/dev/pts

# lvm issue with grub
mkdir /mnt/gentoo/run/lvm
mount --bind /run/lvm /mnt/gentoo/run/lvm

# copy kernel config to root
vendor=$(lspci -v -s 00:00.0 | grep Subsystem | awk '{print $2}')

# set hostname
if [ $vendor == "Hewlett-Packard" ]; then
  newHostName=ecto1
  CPU_FLAGS_X86="aes avx avx2 f16c fma3 mmx mmxext pclmul popcnt sse sse2 sse3 sse4_1 sse4_2 ssse3"
elif [ $vendor == "Lenovo" ]; then
  newHostName=gizmo
  CPU_FLAGS_X86="aes avx avx2 f16c fma3 mmx mmxext pclmul popcnt sse sse2 sse3 sse4_1 sse4_2 ssse3"
fi

# Changing root.

cat > /mnt/gentoo/root/gentoo-init.sh << END
#!/bin/bash

# stop immediately on error
set -e

# problem with LC_CTYPE
unset LC_CTYPE

# sync from web
emerge --sync

# upading configuration
env-update && source /etc/profile

# USE
echo 'USE="systemd networkmanager dbus bluetooth -bindist"' >> /etc/portage/make.conf
echo 'CPU_FLAGS_X86="$CPU_FLAGS_X86"' >> /etc/portage/make.conf
echo 'INPUT_DEVICES="evdev synaptics keyboard mouse mutouch"' >> /etc/portage/make.conf
echo 'dev-lang/python sqlite' >> /etc/portage/package.use/python
echo 'MAKEOPTS="-j5"' >> /etc/portage/make.conf
sed -i '/CFLAGS/d' /etc/portage/make.conf
echo 'CFLAGS="-O2 -pipe -march=native"' >> /etc/portage/make.conf
emerge --update --newuse --deep --quiet @world

# fstab
sed -i '/LABEL=boot/d' /etc/fstab
sed -i '/LABEL=swap/d' /etc/fstab
sed -i '/LABEL=root/d' /etc/fstab
echo -e "UUID=$(blkid -s UUID -t PARTLABEL="EFI system partition" -o value)\t\t\t\t\t\t/boot\tvfat\t\tdefaults\t0 1" >> /etc/fstab
echo -e "UUID=$(blkid -s UUID -t TYPE="ext4" -o value)\t\t/\t\text4\tdefaults\t0 1" >> /etc/fstab

# mount boot
mount /boot

# set locales
echo "de_CH.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo 'LANG="en_GB.UTF-8"' >> /etc/env.d/02locale
echo 'LC_COLLATE="C"' >> /etc/env.d/02locale
env-update && source /etc/profile

# time zone
echo "Europe/Vaduz" > /etc/timezone
emerge --config sys-libs/timezone-data

# kernel
mkdir -p /etc/portage/package.accept_keywords
echo "sys-kernel/gentoo-sources ~amd64" >> /etc/portage/package.accept_keywords/gentoo-sources
emerge sys-kernel/gentoo-sources
wget -P /usr/src/linux/arch/x86/configs https://raw.githubusercontent.com/bluehack42/gentoo/master/kernel/base.config
wget -P /usr/src/linux/arch/x86/configs https://raw.githubusercontent.com/bluehack42/gentoo/master/kernel/$vendor.config
make -C /usr/src/linux defconfig $vendor.config base.config
make -j8 -C /usr/src/linux
make -C /usr/src/linux modules_install
make -C /usr/src/linux install
echo "sys-kernel/linux-firmware *" >> /etc/portage/package.license
emerge sys-kernel/linux-firmware

# luks - crypt disk
mkdir -p /etc/portage/package.use
echo '>=sys-apps/util-linux-2.33-r1 static-libs' > /etc/portage/package.use/util-linux
emerge sys-kernel/genkernel sys-fs/cryptsetup
genkernel --luks --lvm initramfs

# grub
echo "sys-boot/grub:2 device-mapper" >> /etc/portage/package.use/sys-boot
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
emerge --verbose sys-boot/grub:2
echo -e GRUB_CMDLINE_LINUX=\"dolvm crypt_root=UUID=$(blkid -s UUID -t TYPE=crypto_LUKS -o value) root=/dev/mapper/vg0-root root_keydev=$(blkid -s UUID -L SYSTEM) root_key=keyfile key_timeout=5 \" >> /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

# lvm
rc-update add lvm boot

# network manager
emerge net-misc/networkmanager

# dhcpd
emerge net-misc/dhcp

# ndpd
emerge net-misc/ntp
rc-update add ntpd default

# add gentoolkit
emerge gentoolkit

# set keyboard
sed -i 's/keymap=\"us\"/keymap=\"de_CH-latin1\"/g' /etc/conf.d/keymaps
sed -i 's/hostname=\"localhost\"/hostname=\"$newHostName.sourcecode.li\"/g' /etc/conf.d/hostname
echo '$newHostName' > /etc/hostname
echo 'KEYMAP=de_CH-latin1' > /etc/vconsole.conf

# set password for root
passwd -d root

# add user blue and scripts for after install
useradd -d /home/blue -m -G wheel,plugdev,users blue
passwd -d blue

# add vim, git, ansible
echo "net-libs/zeromq drafts" >> /etc/portage/package.use/zeromq
emerge dev-vcs/git app-admin/ansible app-admin/sudo

# sudo for blue
echo "blue ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/blue

# start NetworkManger
systemctl enable NetworkManager

# autologin
mkdir -p /etc/systemd/system/getty@tty1.service.d
echo '#!/bin/bash' > /home/blue/.bashrc
echo 'set -x' >> /home/blue/.bashrc
echo './setup.sh' >> /home/blue/.bashrc
chown blue /home/blue/.bashrc

END

chmod +x /mnt/gentoo/root/gentoo-init.sh

chroot /mnt/gentoo /root/gentoo-init.sh

# copy wifi connections
cp /mnt/cdrom/kleines\ gallisches\ Dorf.nmconnection /mnt/gentoo/etc/NetworkManager/system-connections
chmod 600 /mnt/gentoo/etc/NetworkManager/system-connections/kleines\ gallisches\ Dorf.nmconnection

# autologin
cp /mnt/cdrom/override.conf /mnt/gentoo/etc/systemd/system/getty@tty1.service.d/

# copy git clone 
wget -P /mnt/gentoo/home/blue https://raw.githubusercontent.com/bluehack42/gentoo/master/usb/setup.sh 
chmod +x /mnt/gentoo/home/blue/setup.sh

# Cleaning.

rm /mnt/gentoo/$(basename $STAGE3_URL)
rm /mnt/gentoo/$(basename $PORTAGE_URL)
rm /mnt/gentoo/root/gentoo-init.sh

# Rebooting

# signal that installation is completed before rebooting
for i in `seq 1 10`; do tput bel; done

reboot

