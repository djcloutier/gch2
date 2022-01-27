#!/bin/bash
echo "This script requires genisoimage and p7zip-full"
FILE=focal-live-server-amd64.iso
if test -f "$FILE"; then
    echo "$FILE exists."
    else
    echo "downloading source iso..."
    wget -N https://cdimage.ubuntu.com/ubuntu-server/focal/daily-live/current/focal-live-server-amd64.iso
fi

rm -rf source-files
mkdir source-files

7z -y x focal-live-server-amd64.iso -osource-files
rm -rf source-files/[BOOT]/
cp grub.cfg source-files/boot/grub/
mkdir source-files/server
cp txt.cfg source-files/isolinux/
cp user-data source-files/server/
touch source-files/server/meta-data
cd source-files
echo "creating iso..."
genisoimage -quiet -D -r -V "glatt-hypervisor-focal" -cache-inodes -J -l -joliet-long -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -o  ../glatt-hypervisor-focal.iso .

#disable integrity check
echo > md5sum.txt
echo "done"
