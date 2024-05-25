#!/bin/bash

KERNEL=kernel8.img
DTB=bcm2710-rpi-3-b-plus.dtb
INITRAMFS=~/initramfs.cpio.gz

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
	-M raspi3b -kernel ${KERNEL} \
	-append "console=ttyAMA0,115200 rdinit=/sbin/init" \
	-dtb ${DTB} \
	-initrd ${INITRAMFS}

