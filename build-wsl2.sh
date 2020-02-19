#!/bin/bash

export arg=""
export artifacts="../artifacts/wsl2/"
export defconfig="../../../../configs/wsl2/wsl2_defconfig"
export jobs=12
export kernel_src="../WSL2-Linux-Kernel"

./build-x86-common.sh "wsl2-x86" $1 no-install-modules
