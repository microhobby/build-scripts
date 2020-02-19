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
echo "Version: 💩"
echo "We need super cow powers! 🐄"

sudo echo "WE HAVE THE POWER!"

export O=$artifacts

# go to source folder
cd $kernel_src

if [ "$2" != "no-clean" ]; then
	echo -e "${RED}CLEAN 🧹${NC}"
	# Goto kernel source and clean
	sudo make O=$artifacts distclean
	sudo make O=$artifacts clean
fi

echo -e "${RED}CONFIG 🧰${NC}"
make O=$artifacts $defconfig
lastError=$(lastErrorCheck $lastError)

echo -e "${RED}COMPILE vmlinux 🔥${NC}"
make O=$artifacts -j $jobs
lastError=$(lastErrorCheck $lastError)

echo -e "${RED}COMPILE modules 🔥🔥${NC}"
make O=$artifacts modules -j $jobs
lastError=$(lastErrorCheck $lastError)

if [ "$3" != "no-install-modules" ]; then
	echo -e "${RED}INSTALL modules 🔥🔥🔥${NC}"
	sudo make O=$artifacts INSTALL_MOD_PATH=$path modules_install
	lastError=$(lastErrorCheck $lastError)
	sudo make O=$artifacts ARCH=arm INSTALL_HDR_PATH=$path/usr headers_install
	lastError=$(lastErrorCheck $lastError)
fi

echo "Recording analytics 💾"
cd -
countCompiles=$(wget "http://microhobby.com.br/safira2/kernelbuild.php?name=$1&error=$lastError"  -q -O -)
echo -e "${RED}COMPILED KERNEL :: $countCompiles 📑${NC}"

if [ "$lastError" -ne "0" ]; then
	echo -e "${RED}ERRORS DURING BUILD 😖❌${NC}"
	exit -1
else
	echo -e "${RED}DONE 👌😎${NC}"
	exit $countCompiles
fi
