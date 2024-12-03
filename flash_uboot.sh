#!/bin/bash

/usr/bin/dd if=/boot/u-boot-rockchip.bin of=/dev/mmcblk0 seek=64 conv=notrunc

