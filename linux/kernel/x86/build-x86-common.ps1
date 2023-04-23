#!/usr/bin/env pwsh

##
# Build Kernel Linux for x86
# Environment variables:
#   KERNEL_MACHINE:             the machine name
#   KERNEL_CLEAN:               boolean, clean the kernel build
#   KERNEL_DEFCONFIG:           the kernel config defconfig
#   KERNEL_BUILD_DIR:           the kernel build directory
#   KERNEL_SOURCE_DIR:          the kernel source directory
#   KERNEL_BUILD_JOBS:          the number of jobs to run in parallel
#   KERNEL_INSTALL_MODULES:     boolean, install the kernel modules
#   KERNEL_MODULES_PATH:        the rootfs path to install the modules and headers
##

$ErrorActionPreference = "Stop"
[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSUseDeclaredVarsMoreThanAssignments', "Internal PS variable"
)]
$PSNativeCommandUseErrorActionPreference = $true

Write-Host -ForegroundColor DarkYellow `
    "Build Kernel Linux for $env:KERNEL_MACHINE"
Write-Host -ForegroundColor DarkGray `
    "Version: 🦄"
Write-Host -ForegroundColor DarkGray `
    "Author: Matheus Castello <matheus@castello.eng.br>"
Write-Host -ForegroundColor DarkGray `
    "License: MIT"

try {
    $OLDPWD = Get-Location
    Set-Location $env:KERNEL_SOURCE_DIR

    # check if is need to clean the build
    if ($env:KERNEL_CLEAN -eq $true) {
        Write-Host -ForegroundColor DarkRed `
            "Cleaning the kernel build..."

        make O=$env:KERNEL_BUILD_DIR distclean
        make O=$env:KERNEL_BUILD_DIR clean
    }

    # build the kernel
    Write-Host -ForegroundColor DarkGreen `
        "Building the kernel..."

    Write-Host -ForegroundColor DarkGray `
        "CONFIG 🧰"
    make O=$env:KERNEL_BUILD_DIR $env:KERNEL_DEFCONFIG

    Write-Host -ForegroundColor DarkGray `
        "COMPILE vmlinux 🔥"
    make O=$env:KERNEL_BUILD_DIR -j $env:KERNEL_BUILD_JOBS

    Write-Host -ForegroundColor DarkGray `
        "COMPILE modules 🔥🔥"
    make O=$env:KERNEL_BUILD_DIR modules -j $env:KERNEL_BUILD_JOBS

    if ($env:KERNEL_INSTALL_MODULES -eq $true) {
        Write-Host -ForegroundColor DarkGray `
            "INSTALL modules 📦"
        make O=$env:KERNEL_BUILD_DIR INSTALL_MOD_PATH=$env:KERNEL_MODULES_PATH modules_install
        make O=$env:KERNEL_BUILD_DIR ARCH=x86 INSTALL_HDR_PATH=$env:KERNEL_MODULES_PATH/usr headers_install
    }

    Write-Host -ForegroundColor DarkGreen `
        "Kernel build finished! 👌😎"
} finally {
    Set-Location $OLDPWD
}
