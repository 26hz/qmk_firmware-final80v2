#!/bin/bash

_qmk_install_prepare() {
    echo "This script will make a USE change in order to ensure that that QMK works on your system."
    echo "All changes will be sent to the file /etc/portage/package.use/qmkfirmware -- please review it, and read Portage's output carefully before installing any packages on your system."
    echo "You will also need to ensure that your kernel is compiled with support for the microcontroller that you are using (e.g. enable Arduino for the Pro Micro). Further information can be found on the Gentoo wiki."

    read -p "Proceed? [y/N] " res
    case $res in
        [Yy]*)
            return 0;;
        *)
            return 1;;
    esac
}

_qmk_install() {
    echo "Installing dependencies"

    doas touch /etc/portage/package.use/qmkfirmware
    # tee is used here since doas doesn't apply to >>
    echo "sys-devel/gcc multilib" | doas tee --append /etc/portage/package.use/qmkfirmware >/dev/null
    doas emerge -auN sys-devel/gcc
    doas emerge -au --noreplace \
        app-arch/unzip app-arch/zip net-misc/wget sys-devel/clang sys-devel/crossdev \
        \>=dev-lang/python-3.7 \
        dev-embedded/avrdude dev-embedded/dfu-programmer app-mobilephone/dfu-util

    doas crossdev -s4 --stable --g \<9 --portage --verbose --target avr
    doas crossdev -s4 --stable --g \<9 --portage --verbose --target arm-none-eabi

    python3 -m pip install --user -r $QMK_FIRMWARE_DIR/requirements.txt
}
