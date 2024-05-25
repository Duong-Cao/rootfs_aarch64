#!/bin/bash

KERNEL=kernel8.img
DTB=bcm2710-rpi-3-b-plus.dtb
IMGDISK=/home/duogcao/rootfs.ext2
INITRAMFS=/home/duogcao/initramfs.cpio.gz

if [ ! -f ${KERNEL} ]; then
	echo "${KERNEL} does not exist"
	exit 1
fi
if [ ! -f ${DTB} ]; then
	echo "${DTB} does not exist"
	exit 1
fi

QEMU_AUDIO_DRV=none \
qemu-system-aarch64 \
	-m 1G -nographic \
	-M raspi3b \
	-cpu cortex-a72 \
	-kernel ${KERNEL} \
	-append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/home/duogcao/rootfs rootfstype=ext4 init=/etc/lib/inittab rootdelay=1" \
	-dtb ${DTB} -usb -device usb-mouse -device usb-kbd -device usb-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:22 \
	-initrd ${INITRAMFS} 
