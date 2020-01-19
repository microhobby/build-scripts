#!/bin/bash

## I changed
# fatload ${devtype} ${devpart} ${kernel_addr_r} uImage.old

## to access the board
# ssh lkcamp@repfrancesfurtivo.ddns.net -p 17409

export arg=""
export path="/media/castello/SYSTEM"
export path_boot="/media/castello/BOOT"
export artifacts="../artifacts/labrador/"
export defconfig="../../../../configs/labrador/labrador_defconfig"
export jobs=12
export kernel_src="../linux"

./build-armhf-common.sh "Caninos-Labrador-v2" $1 no-install-modules
