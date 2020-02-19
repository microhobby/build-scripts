#!/bin/bash

RED='\x1b[42;37m'
NC='\033[0m' # No Color
lastError=0

# last error check
function lastErrorCheck () {
	lst=$?
	if [ "$lst" -ne "0" ]; then
		echo $lst
	else
		echo $1 
	fi
}

echo -e "${RED}KERNEL BUILD FOR $1 ${NC}"
echo "Author: Matheus Castello <matheus@castello.eng.br>"
echo "Version: 🌠"
echo "We need super cow powers! 🐄"

sudo echo "WE HAVE THE POWER!"

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export O=$artifacts

# go to source folder
cd $kernel_src

if [ "$2" != "no-clean" ]; then
	echo -e "${RED}CLEAN 🧹${NC}"
	# Goto kernel source and clean
	sudo make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=$artifacts distclean
	sudo make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=$artifacts clean
fi

echo -e "${RED}CONFIG 🧰${NC}"
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=$artifacts $defconfig
lastError=$(lastErrorCheck $lastError)

echo -e "${RED}COMPILE zImage 🔥${NC}"
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=$artifacts zImage -j $jobs
lastError=$(lastErrorCheck $lastError)

echo -e "${RED}COMPILE modules 🔥🔥${NC}"
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=$artifacts modules -j $jobs
lastError=$(lastErrorCheck $lastError)

if [ "$3" != "no-install-modules" ]; then
	echo -e "${RED}INSTALL modules 🔥🔥🔥${NC}"
	sudo make O=$artifacts INSTALL_MOD_PATH=$path modules_install
	lastError=$(lastErrorCheck $lastError)
	sudo make O=$artifacts ARCH=arm INSTALL_HDR_PATH=$path/usr headers_install
	lastError=$(lastErrorCheck $lastError)
fi

echo -e "${RED}COMPILE dtb 🔥🔥🔥🔥${NC}"
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=$artifacts dtbs -j $jobs
lastError=$(lastErrorCheck $lastError)

echo "Recording analytics 💾"
cd -
countCompiles=$(wget "http://microhobby.com.br/safira2/kernelbuild.php?name=$1&error=$lastError"  -q -O -)
echo -e "${RED}COMPILED KERNEL :: $countCompiles 📑${NC}"

if [ "$lastError" -ne "0" ]; then
	echo -e "${RED}ERRORS DURING BUILD 😖❌${NC}"
	exit -1
else
	if [ "$3" != "no-install-modules" ]; then
		echo -e "${RED}COPY TO SDCARD 💾${NC}"
		cd -
		cd $artifacts

		# umount and copy if we have paths
		if [ "$path_boot" != "" ]; then
			sudo cp arch/arm/boot/dts/*$dtb_prefix* $path_boot
			sudo cp arch/arm/boot/zImage $path_boot
			sudo umount $path_boot
		fi

		if [ "$path" != "" ]; then
			sudo umount $path
		fi

		if [ "$path_ramdisk" != "" ]; then
			sudo umount $path_ramdisk
		fi
	fi
	
	echo -e "${RED}DONE 👌😎${NC}"
	exit $countCompiles
fi
