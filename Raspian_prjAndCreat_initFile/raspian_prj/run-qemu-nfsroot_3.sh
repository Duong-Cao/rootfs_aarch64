#!/bin/bash

KERNEL=kernel8.img
DTB=bcm2710-rpi-3-b-plus.dtb
ROOTDIR=/home/duogcao/rootfs
HOST_IP=192.168.1.1
TARGET_IP=192.168.1.101
NET_NUMBER=192.168.1.0
NET_MASK=255.255.255.0
INITRAMFS=/home/duogcao/initramfs.cpio.gz

if [ ! -f ${KERNEL} ]; then
	echo "${KERNEL} does not exist"
	exit 1
fi
if [ ! -f ${DTB} ]; then
	echo "${DTB} does not exist"
	exit 1
fi

sudo tunctl -u $(whoami) -t tap0
sudo ifconfig tap0 ${HOST_IP}
sudo route add -net ${NET_NUMBER} netmask ${NET_MASK} dev tap0
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

QEMU_AUDIO_DRV=none \
qemu-system-arm64 \
	-m 1G \
	-cpu cortex-a72 \
	-nographic \
	-M raspi3b \
	-kernel ${KERNEL} \
	-append "console=ttyAMA0,115200 root=/dev/nfs rw nfsroot=${HOST_IP}:${ROOTDIR},v3 ip=${TARGET_IP}" \
	-initrd ${INITRAMFS} \
	-netdev tap,ifname=tap0,script=no,downscript=no \
	-dtb ${DTB}

