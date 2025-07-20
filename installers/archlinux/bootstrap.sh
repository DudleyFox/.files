#!/usr/bin/sh
set -e

if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run by root' >&2
        exit 1
fi

useradd -m fox
pacman -Sy --noconfirm sudo
pacman -Sy --noconfirm openssh

echo "" >> /etc/sudoers
echo "fox   ALL=(ALL:ALL) ALL" >> /etc/sudoers

echo "Set the password for fox:"
passwd fox

echo "Run the install.sh script next as the user fox"
