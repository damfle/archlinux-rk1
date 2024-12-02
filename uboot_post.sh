#!/bin/bash

KERNEL_FILE="$1"
INITRAMFS_FILE="$2"

mkimage -A arm64 -T ramdisk -C zstd -n uInitrd -d "${INITRAMFS_FILE}" -b /boot/dtbs/rockchip/rk3588-turing-rk1.dtb /boot/uInitrd-rk1
