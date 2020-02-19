#!/bin/bash

export arg=""
export artifacts="../artifacts/qemu-x86/"
export defconfig="../../../../configs/qemu-x86/qemux86_defconfig"
export jobs=12
export kernel_src="../linux"

./build-x86-common.sh "qemu-x86" $1 no-install-modules
