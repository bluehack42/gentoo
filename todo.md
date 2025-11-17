stop i3lock when /opt/zoom/aomhost is alive

kernel:
CONFIG_KEY_DH_OPERATIONS

add packages:
 * Install additional packages for optional runtime features:
 *   net-misc/networkmanager for Networking support
 *   sys-fs/btrfs-progs for Scan for Btrfs on block devices
 *   net-fs/cifs-utils for Support CIFS
 *   sys-fs/cryptsetup[-static-libs] for Decrypt devices encrypted with cryptsetup/LUKS
 *   app-shells/dash for Allows use of dash instead of default bash (on your own risk)
 *   sys-apps/busybox for Allows use of busybox instead of default bash (on your own risk)
 *   sys-block/open-iscsi for Support iSCSI
 *   sys-fs/lvm2[lvm] for Support Logical Volume Manager
 *   sys-fs/mdadm for Support MD devices, also known as software RAID devices
 *   sys-fs/dmraid for Support MD devices, also known as software RAID devices
 *   sys-fs/multipath-tools for Support Device Mapper multipathing
 *   >=sys-boot/plymouth-0.8.5-r5 for Plymouth boot splash
 *   sys-block/nbd for Support network block devices
 *   net-fs/nfs-utils for Support NFS
 *   net-nds/rpcbind for Support NFS
 *   app-admin/rsyslog for Enable logging with rsyslog
 *   sys-fs/squashfs-tools for Support Squashfs
 *   app-crypt/tpm2-tools for Support TPM 2.0 TSS
 *   net-wireless/bluez for Support Bluetooth (experimental)
 *   sys-apps/biosdevname for Support BIOS-given device names
 *   sys-apps/nvme-cli for Support network NVMe
 *   app-misc/jq for Support network NVMe
 *   sys-apps/rng-tools for Enable rngd service to help generating entropy early during boot
 *   sys-kernel/installkernel[dracut] for automatically generating an initramfs on each kernel installation