#!/bin/bash

# this is a script to upgrade the kernel on a fucked up macbookpro. call this when
# installing a new kernel and it:
# -installs https://github.com/PatrickVerner/macbook12-spi-driver
# -installs audio drivers

# some ifs to check if
if ! grep -q "applespi" /etc/initramfs-tools/modules; then
    echo -e "\n# applespi\napplespi\nspi_pxa2xx_platform\nintel_lpss_pci" >> /etc/initramfs-tools/modules
    echo "///wrote touchbar driver load to initramfs"
fi

# yeah so it's weird but we need to blacklist one of the things we install
# too lazy to delve into that enigma but i think we're only using the codec from the driver
if ! grep -q "blacklist snd-hda-codec-cs8409" /etc/modprobe.d/blacklist.conf; then
    echo -e "\nblacklist snd-hda-codec-cs8409" >> /etc/modprobe.d/blacklist.conf
    echo "///blacklisted cs8409 codec"
fi

# touchbar drivers-actually for the shared interface for bar, keeb, touchpad, camera, though some
# of that works without it
echo "wiping old bar driver"
rm -r /usr/src/applespi-0.1/
echo "///downloading latest bar driver"
git clone https://github.com/PatrickVerner/macbook12-spi-driver.git /usr/src/applespi-0.1
echo "///installing bar driver"
dkms install -m applespi -v 0.1

# audio
# base driver
echo "///cloning audio driver into pwd"
git clone https://github.com/davidjo/snd_hda_macbookpro
cd snd_hda_macbookpro || exit
echo "///installing audio driver"
bash install.cirrus.driver.sh &&
echo "///wiping cloned files"
cd .. || echo "///wipe failed" && exit
rm -fr snd_hda_macbookpro

# codec for the audio chip
echo "///cloning codec into pwd"
git clone https://github.com/egorenar/snd-hda-codec-cs8409
cd snd-hda-codec-cs8409 || exit
echo "///building codec"
make
echo "///installing codec"
make install
echo "///wiping cloned files"
cd .. || echo "///wipe failed" && exit 
rm -fr snd-hda-codec-cs8409
