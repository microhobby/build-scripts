#!/usr/bin/env pwsh

##
# Build Kernel Linux for WSL 2
##

$env:KERNEL_MACHINE             = "WSL 2 Mainline"
#$env:KERNEL_CLEAN               = $true
$env:KERNEL_DEFCONFIG           = "../../../../configs/wsl2/wsl2_defconfig"
$env:KERNEL_BUILD_DIR           = "../artifacts/wsl2-mainline"
$env:KERNEL_SOURCE_DIR          = "../../../../linux"
$env:KERNEL_BUILD_JOBS          = 20
$env:KERNEL_INSTALL_MODULES     = $false
$env:KERNEL_MODULES_PATH        = $null

# call the common build script
. ./../../../linux/kernel/x86/build-x86-common.ps1
