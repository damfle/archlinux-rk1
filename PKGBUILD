# U-Boot: Turing RK1
# Maintainer: Damien FLETY <damfle+archlinux@sloth.ninja>

buildarch=8

pkgname=uboot-rk1
pkgver=2024.10
pkgrel=1
pkgdesc="U-Boot for Turing Pi RK1"
arch=('aarch64')
url='http://www.denx.de/wiki/U-Boot/WebHome'
license=('GPL')
backup=('boot/uboot.env')
makedepends=('bc' 'git' 'python' 'python-pyelftools' 'swig' 'dtc' 'uboot-tools')
_srcname=u-boot
_gitbranch=v2024.10
source=(
        "${_srcname}::git+https://github.com/u-boot/u-boot#tag=${_gitbranch}"
        "rkbin::git+https://github.com/rockchip-linux/rkbin"
        "config"
        "uboot_post.sh"
        "linux-efi.preset"
      )
sha256sums=('SKIP'
            'SKIP'
            '0444b46f068451c2549c7612f1dd8b503deeb3996b79644776cf24a17da59dc9'
            '3a56a352c747c830f89a948ecfdc90b4a9fd12bd04113a6d6cc62aa1e435f281'
            '77bcd85f5b31cd935c0e331cd3d0b3633e18d1b209aaa865f4cf3df16fe07228'
      )

build() {
  export ROCKCHIP_TPL="${srcdir}/rkbin/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.16.bin"
  export BL31="${srcdir}/rkbin/bin/rk35/rk3588_bl31_v1.45.elf"

  cp config ${srcdir}/u-boot/.config

  cd ${srcdir}/u-boot

  unset CLFAGS CXXFLAGS CPPFLAGS LDFLAGS

  make oldconfig
  make -j10
}

package() {
  mkdir -p "${pkgdir}/etc/initcpio/post/"

  sed "${_subst}" ../uboot_post.sh |
    install -Dm744 /dev/stdin "${pkgdir}/etc/initcpio/post/uboot_post.sh"

  mkdir -p "${pkgdir}/etc/mkinitcpio.d/"
  
  # install mkinitcpio preset file
  sed "${_subst}" ../linux-efi.preset |
    install -Dm644 /dev/stdin "${pkgdir}/etc/mkinitcpio.d/linux-efi.preset"
  
  cd u-boot

  mkdir -p "${pkgdir}/boot"
  cp u-boot-rockchip.bin "${pkgdir}/boot/u-boot-rockchip.bin"
}

