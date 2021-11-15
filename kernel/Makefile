vendor = $(shell lspci -v -s 00:00.0 | grep Subsystem | awk '{print $$2}')

downloadConfig:
	curl https://hackerone.com/reports/887462 > /usr/src/linux/arch/x86/configs
	curl https://raw.githubusercontent.com/bluehack42/gentoo/master/kernel/$(vendor).config > /usr/src/linux/arch/x86/configs

createConfig:
	make -C /usr/src/linux defconfig $(vendor).config base.config

createKernel:
	make -j8 -C /usr/src/linux
	make -j8 -C /usr/src/linux modules_install
	make -j8 -C /usr/src/linux install
	genkernel --luks --lvm initramfs
	grub-mkconfig -o /boot/grub/grub.cfg
