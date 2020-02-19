#!/bin/bash

qemu-system-arm \
	-M versatilepb \
	-cpu arm1176 \
	-m 256 \
	-kernel /home/castello/linus-tree/artifacts/qemu/kernel-qemu-4.19.50-buster \
	-dtb /home/castello/linus-tree/artifacts/qemu/versatile-pb.dtb \
	-initrd /home/castello/linus-tree/busybox/work/lasco \
	-append 'earlycon rdinit=/init loglevel=8' \
	-no-reboot \
	-no-shutdown \
	-nographic \
	-nodefaults \
	-serial stdio

: '
qemu-system-aarch64 \
	-M raspi3 \
	-cpu cortex-a53 \
	-m 1024 \
	-kernel /home/castello/linus-tree/artifacts/bcm2837_pi3b/arch/arm/boot/zImage \
	-dtb /home/castello/linus-tree/artifacts/bcm2837_pi3b/arch/arm/boot/dts/bcm2837-rpi-3-b.dtb \
	-append 'earlycon'
'

: '
qemu-system-arm \
	-M raspi2 \
	-cpu cortex-a7 \
	-m 1024 \
	-kernel pi-tools/kernel7.img \
	-dtb pi-tools/bcm2709-rpi-2-b.dtb \
	-append 'earlycon dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait'
'
