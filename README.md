archlinux-rk1
====================

This is just a POC. It's only for other people with embedded skills. I do not intend to provide support for this.

Packages for basic ArchlinuxArm support on the [Turing RK1](https://turingpi.com/product/turing-rk1) board.
Also add support for UEFI UKI image since initramfs doesn't work yet (and I personally prefer UEFI), as well as support for selinux/apparmor.


## Build
### On platform

You can build them like any other Archlinux package. `cd` into the package directory and run `makepkg`.

`makepkg -si`

### Cross compile

This require cross compiling which is harder, this is the command line I used for building the kernel.
The `ARCH` environment variable is only necessary for linux.

`ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- CARCH=aarch64 CHOST=aarch64-linux-gnu- makepkg -si`

## Compile a bootable image

Please be careful on where you are running theses commands. You may brick your machine or storage.

### Create an empty image of approx 4G with `dd`

`dd if=/dev/zero of=archlinux-rk1.img bs=512 count=8000000`

### Mount image

`losetup -P /dev/loop0 archlinux-rk1.img`

### Define partitions

`fdisk /dev/loop0`

I use GPT partitions with one vfat for UEFI and one ext4 for the system.

- `g` - new gpt partition table
- `n` - new partition
- `1` - partition #1
- `32768` - start sector, first 32k sectors are for uboot bootloader so skip them
- `+256M` - end sector, 256M for UEFI
- `t` - change partition type
- `uefi` - alias to UEFI
- `n` - new partition
- `2` - partition #2
- `FIXME` - start sector, should be around 50k, you can see it by running `p` command before this one
- `BLANK` - end sector, all space that is left on the image
- `w` - write and exit

### Initialize partitions

Set up the filesystem.

Create a fat32 partition for UEFI

`mkfs.vfat -F32 /dev/loop0p1`

Create an ext4 partition for the system

`mkfs.ext4 /dev/loop0p2`

Then mount the partitions

`mount /dev/loop0p2 /mnt`

`mount --mkdir /dev/loop0p1 /mnt/boot`

### Install

Extract the base archlinux ARM image or pacstrap it, follow the instructions on the [archlinuxarm](https://archlinuxarm.org/platforms/armv8/generic) website.
Note that the archlinuxarm base images are pretty old so I'm using `pacstrap` that is included the package `arch-install-scripts`.

### Install the bootloader

This is needed for the image to be able to boot. Once packages of this repository are builts, install them into the root of the target filesystem.

`dd if=/mnt/boot/u-boot-rockchip.bin of=/dev/loop0 seek=64 conv=notrunc`


### Unmount everything

If one of theses commands don't work, you are probably still into a mounted directory.

`sync`

`umount /mnt/boot`

`umount /mnt`

`losetup -d /dev/loop0`

And you're done. You now have an image that you can flash through the webui or via `scp` and `tpi` utilities (which I highly recommend).
