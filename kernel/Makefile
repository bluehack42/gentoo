vendor = $(shell lspci -v -s 00:00.0 | grep Subsystem | awk '{print $$2}')
threads = $(nproc)

downloadConfig:
	curl https://raw.githubusercontent.com/bluehack42/gentoo/master/kernel/base.config > /usr/src/linux/arch/x86/configs/base.config
	curl https://raw.githubusercontent.com/bluehack42/gentoo/master/kernel/$(vendor).config > /usr/src/linux/arch/x86/configs/$(vendor).config

cpConfigs: 
	cp base.config /usr/src/linux/arch/x86/configs
	cp $(vendor).config /usr/src/linux/arch/x86/configs

createConfig:
	make -C /usr/src/linux defconfig $(vendor).config base.config

createKernel:
	make -j $(threads) -C /usr/src/linux
	make -j $(threads) -C /usr/src/linux modules_install
	make -j $(threads) -C /usr/src/linux install
	genkernel --luks --lvm initramfs
	grub-mkconfig -o /boot/grub/grub.cfg

localTest: cpConfigs createConfig createKernel

all: downloadConfig createConfig createKernel
