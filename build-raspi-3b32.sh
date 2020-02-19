#!/bin/bash

export arg=""
export path="/media/castello/rootfs"
export path_boot="/media/castello/boot"
export path_ramdisk=""
export artifacts="../artifacts/bcm2837_pi3b/"
export defconfig="../../../../configs/bcm2837-rpi3/pi3b_defconfig"
export dtb_prefix="bcm"
export jobs=12
export kernel_src="../linux"

./build-armhf-common.sh "Raspberry-Pi-3b-32" $1 $2
