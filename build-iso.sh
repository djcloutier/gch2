#!/bin/bash

#check if p7zip is installed
if ! type 7z > /dev/null; then
    echo "7z is not installed. Please install it and try again."
    exit 1
fi
#check if genisoimage is installed
if ! type genisoimage > /dev/null; then
    echo "genisoimage is not installed. Please install it and try again."
    exit 1
fi

FILE=focal-live-server-amd64.iso
if test -f "$FILE"; then
    echo "$FILE exists."
    else
    echo "downloading source iso..."
    wget -N https://cdimage.ubuntu.com/ubuntu-server/jammy/daily-live/current/jammy-live-server-amd64.iso
fi

rm -rf source-files
mkdir source-files

7z -y x jammy-live-server-amd64.iso -osource-files
rm -rf source-files/[BOOT]/
cp grub.cfg source-files/boot/grub/
mkdir source-files/server
cp txt.cfg source-files/isolinux/
cp user-data source-files/server/
touch source-files/server/meta-data
cd source-files
echo "creating iso..."
genisoimage -quiet -D -r -V "glatt-hypervisor-jammy" -cache-inodes -J -l -joliet-long -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -o  ../glatt-hypervisor-jammy.iso .

#disable integrity check
echo > md5sum.txt
echo "done"
