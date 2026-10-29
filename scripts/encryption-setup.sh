#!/usr/bin/env bash
# Create a LUKS-encrypted ext4 data disk for the NAS and mount it.
# Use this instead of disk-setup.sh, not after it: both format the partition.
#
#   sudo ./encryption-setup.sh /dev/sda1 [/mnt/nas-storage] [mapper-name]
#
# DESTROYS ALL DATA on the given partition. cryptsetup asks you to confirm and
# to choose a passphrase; keep that passphrase somewhere safe - without it the
# data is unrecoverable.
set -euo pipefail

DEVICE="${1:-}"
MOUNT_POINT="${2:-/mnt/nas-storage}"
NAME="${3:-encrypted_nas}"

if [[ -z "$DEVICE" ]]; then
    echo "usage: sudo $0 <partition, e.g. /dev/sda1> [mount point] [mapper name]" >&2
    exit 2
fi
if [[ $EUID -ne 0 ]]; then
    echo "run as root (sudo)" >&2
    exit 1
fi
if [[ ! -b "$DEVICE" ]]; then
    echo "$DEVICE is not a block device; check lsblk" >&2
    exit 1
fi
if findmnt -rn -S "$DEVICE" >/dev/null; then
    echo "$DEVICE is mounted; unmount it first" >&2
    exit 1
fi

echo "Setting up LUKS encryption on $DEVICE..."
cryptsetup luksFormat --type luks2 "$DEVICE"
cryptsetup open "$DEVICE" "$NAME"

echo "Creating ext4 file system..."
mkfs.ext4 -L nas-storage "/dev/mapper/$NAME"

mkdir -p "$MOUNT_POINT"
mount "/dev/mapper/$NAME" "$MOUNT_POINT"

UUID="$(blkid -s UUID -o value "$DEVICE")"
echo "Encrypted disk mounted at $MOUNT_POINT."
echo "To unlock at boot, add to /etc/crypttab:"
echo "  $NAME  UUID=$UUID  none  luks"
echo "and to /etc/fstab:"
echo "  /dev/mapper/$NAME  $MOUNT_POINT  ext4  defaults,noatime,nofail  0  2"
