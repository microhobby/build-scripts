#!/bin/bash

arg=""
path="/media/castello/rootfs"
path_boot="/media/castello/boot"
artifacts="../artifacts/wsl2/"
defconfig="/home/castello/linus-tree/configs/wsl2/wsl2_defconfig"
jobs=12

RED='\x1b[42;37m'
NC='\033[0m' # No Color

echo -e "${RED}KERNEL MAINLINE DEBIAN ON ODYSSEY${NC}"
echo "Author: Matheus Castello <matheus@castello.eng.br>"
echo "Version: 0.0"
echo "We need super cow powers!"

echo "WE HAVE THE POWER!"

export ARCH=x86
export O=$artifacts

echo -e "${RED}CLEAN${NC}"

#cd ../WSL2-Linux-Kernel
cd ../linux
# Goto kernel source and clean
make distclean O=$artifacts
make clean O=$artifacts

echo -e "${RED}CONFIG x86_64${NC}"
echo -e "${RED}COMPILE KERNEL${NC}"

# set config
make O=$artifacts KCONFIG_CONFIG=$defconfig -j 12

# Compile kernel
#make O=$artifacts -j 12
# install modules
# make O=$artifacts modules_install -j 12
# install new kernel headers
# make O=$artifacts headers_install
# install new kernel
# make O=$artifacts install -j 12

cd -
