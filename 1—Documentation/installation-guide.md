# Installation Guide

## Step 1: Install Raspberry Pi OS

Download Raspberry Pi OS Lite and flash it to an SD card.

Enable SSH before first boot.

## Step 2: Update the system

sudo apt update
sudo apt upgrade

## Step 3: Install OpenMediaVault

wget -O - https://github.com/OpenMediaVault-Plugin-Developers/installScript/raw/master/install | sudo bash

After installation, reboot the system.

## Step 4: Access Web Interface

Open a browser and navigate to:

http://raspberrypi.local

Default credentials:

username: admin
password: openmediavault

**Change this password immediately** (User settings → Change password). The
default is public, and anyone on your network could otherwise administer the
NAS.

## Step 5: Configure Storage

1. Connect the external SSD and find its partition with `lsblk` (e.g. `/dev/sda1`)
2. Format it — choose one:
   - encrypted (recommended): `sudo scripts/encryption-setup.sh /dev/sda1`
   - unencrypted: `sudo scripts/disk-setup.sh /dev/sda1`

   Both erase the partition and ask you to confirm. Do not run both.
3. Add the `/etc/fstab` (and, if encrypted, `/etc/crypttab`) lines the script prints
4. Mount the disk in OpenMediaVault
