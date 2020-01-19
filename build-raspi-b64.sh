#!/bin/bash

arg=""
path="/media/castello"

RED='\x1b[42;37m'
NC='\033[0m' # No Color

echo -e "${RED}BUILD SCRIPT FOR BUILD MAINLINE KERNEL LINUX RASPBERRY PI 3B 64bits${NC}"
echo "Author: Matheus Castello <matheus@mpro3.com.br>"
echo "Version: 0.0"
echo ""

echo -e "${RED}SETTING LINARO TOOLCHAIN GCC 6${NC}"

# Goto kernel source and clean
cd ../linux

echo -e "${RED}CLEANING${NC}"
#make distclean

echo -e "${RED}CONFIG BRCM2835${NC}"

# set config
KERNEL=kernel
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig

echo -e "${RED}COMPILE KERNEL${NC}"

# Compile kernel
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs -j 8

echo -e "${RED}INSTALL MODULES${NC}"

# Install modules
echo "INSTALL MODULES"
sudo make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=$path/rootfs modules_install

echo -e "${RED}COMPILE U-BOOT${NC}"

# compile u-boot
cd -
cd ../u-boot

#make clean
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- rpi_3_32b_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j 8

echo -e "${RED}MAKE BOOT CMD${NC}"

# make boot.scr
cd -
cd ../u-boot/tools

echo -e "${RED}COMPILE CMDLINE${NC}"

./mkimage -A arm -O linux -T script -C none -n ../../build-scripts/pi-tools/bootzero.scr -d ../../build-scripts/pi-tools/bootzero.scr ../../build-scripts/pi-tools/boot.scr.uimg

echo -e "${RED}COPY U-BOOT TO SDCARD${NC}"

# copy u-boot
cd -
cd ../u-boot
sudo cp u-boot.bin $path/boot/
cd -
cd pi-tools
sudo cp boot.scr.uimg $path/boot/
cd -
cd ../linux
sudo cp arch/arm/boot/zImage $path/boot/
#sudo cp arch/arm/boot/dts/bcm2835-rpi-zero-w.dtb $path/boot/
#sudo cp arch/arm/boot/dts/bcm2835-rpi-b.dtb $path/boot/
sudo cp arch/arm/boot/dts/bcm2837-rpi-3-b.dtb $path/boot/

echo -e "${RED}COPY FIRMWARE TO SDCARD${NC}"

# copy firmware TODO update firmware from binaries
: '
cd -
cd pi-vendor
sudo cp bootcode.bin $path/boot/
sudo cp start.elf $path/boot/
sudo cp config.txt $path/boot/

cd -
'

sudo umount $path/boot/
sudo umount $path/rootfs/

echo "End of Build Script"
