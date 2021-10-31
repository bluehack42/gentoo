vendor = $(shell lspci -v -s 00:00.0 | grep Subsystem | awk '{print $$2}')

downloadConfig:
	wget -P /usr/src/linux/arch/x86/configs https://raw.githubusercontent.com/bluehack42/gentoo/master/kernel/base.config
	wget -P /usr/src/linux/arch/x86/configs https://raw.githubusercontent.com/bluehack42/gentoo/master/kernel/$(vendor).config

createConfig:
	make -C /usr/src/linux defconfig $(vendor).config base.config

createKernel:
	make -j8 -C /usr/src/linux
	make -j8 -C /usr/src/linux modules_install
	make -j8 -C /usr/src/linux install
	grub-mkconfig -o /boot/grub/grub.cfg
