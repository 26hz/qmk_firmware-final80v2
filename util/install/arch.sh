#!/bin/bash

_qmk_install() {
    echo "Installing dependencies"

    doas pacman --needed  --noconfirm -S \
        base-devel clang diffutils gcc git unzip wget zip \
        python-pip \
        avr-binutils \
        arm-none-eabi-binutils arm-none-eabi-gcc arm-none-eabi-newlib \
        avrdude dfu-programmer dfu-util
    doas pacman --needed --noconfirm -U https://archive.archlinux.org/packages/a/avr-gcc/avr-gcc-8.3.0-1-x86_64.pkg.tar.xz
    doas pacman --needed --noconfirm -S avr-libc # Must be installed after the above, or it will bring in the latest avr-gcc instead

    python3 -m pip install --user -r $QMK_FIRMWARE_DIR/requirements.txt
}
