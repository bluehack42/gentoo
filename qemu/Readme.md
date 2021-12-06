## Qemu use

### Create img

'''bash
qemu-img create -f qcow2 ubuntu.img 10G
'''

qcow2 = Qemu Copy On Write Second edition


### start image
'''
qemu-system-x86_64 -enable-kvm -cdrom /home/blue/Downloads/ubuntu-21.04-desktop-amd64.iso -boot menu=on -drive file=qemu/ubuntu.img -m 2G'''
