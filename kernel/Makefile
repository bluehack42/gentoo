vendor = $(shell lspci -v -s 00:00.0 | grep Subsystem | awk '{print $$2}')

testConfig:
	wget -P /usr/src/linux/arch/x86/configs https://raw.githubusercontent.com/bluehack42/gentoo/master/kernel/base.config
	wget -P /usr/src/linux/arch/x86/configs https://raw.githubusercontent.com/bluehack42/gentoo/master/kernel/$(vendor).config
