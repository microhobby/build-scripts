#!/bin/bash

# TODO check for this configs on .config
# CONFIG_BLK_DEV_INITRD=y
# CONFIG_INITRAMFS_SOURCE=""
# CONFIG_RD_GZIP=y

# utils
export path_boot="/media/castello/BOOT"
export path_ramdisk="/media/castello/ramdisco"

echo "We need super cow powers! 🐄"
sudo echo "WE HAVE THE POWER!"

## create work folder
cd ../busybox
mkdir -p work/initramfs/{bin,sbin,etc,proc,sys,newroot}

## config busybox
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- clean
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- defconfig

## Busybox Settings --> Build Options -->
##	Build Busybox as a static binary (no shared libs)
##	 -  Enable this option by pressing "Y"
#make menuconfig

## build
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-

## "install" the binary
cp busybox work/initramfs/bin/
chmod +x work/initramfs/bin/busybox

## create the mdev
cd work
#touch initramfs/etc/mdev.conf

## create init
#touch initramfs/init
#chmod +x initramfs/sbin/init

## this only for the kernel decompressed
## create the .cpio
cd initramfs
find . | cpio -ov --format=newc | gzip -9 >../lasco
cd - 

# this do not work on raspberry pi
: '
find . | cpio -H newc -o > ../initramfs.cpio
cd ..
cat initramfs.cpio | gzip > initramfs.igz
'

## u-boot
mkimage \
	-A arm \
	-T ramdisk \
	-C none \
	-n "ramdisk" \
	-d lasco lasco.img


## copy to boot partition
#sudo cp initramfs.igz $path_boot

## SDCard gambiarra
#sudo cp -r initramfs/* $path_ramdisk
#sudo dd if=/dev/mmcblk0p3 of=./lasco

echo "Done"
