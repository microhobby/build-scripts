#!/bin/bash

export arg=""
export path="/media/castello/rootfs"
export path_boot="/media/castello/boot"
export artifacts="../artifacts/imx7_torizon/"
export defconfig="../../../../configs/torizon-imx7/torizon_colibri_imx7_defconfig"
export jobs=12
export kernel_src="../linux"

./build-armhf-common.sh "Torizon-Colibri-iMX7" $1 $2
