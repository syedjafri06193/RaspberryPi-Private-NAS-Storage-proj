#!/usr/bin/env bash
# Format and mount an UNENCRYPTED data disk for the NAS.
# For an encrypted disk use encryption-setup.sh instead (not both: each one
# formats the partition).
#
#   sudo ./disk-setup.sh /dev/sda1 [/mnt/nas-storage]
#
# DESTROYS ALL DATA on the given partition. You are asked to type the device
# name to confirm.
set -euo pipefail

DEVICE="${1:-}"
MOUNT_POINT="${2:-/mnt/nas-storage}"

if [[ -z "$DEVICE" ]]; then
    echo "usage: sudo $0 <partition, e.g. /dev/sda1> [mount point]" >&2
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

lsblk -o NAME,SIZE,MODEL,FSTYPE,MOUNTPOINT "$DEVICE"
read -r -p "This erases everything on $DEVICE. Type the device name to continue: " answer
if [[ "$answer" != "$DEVICE" ]]; then
    echo "aborted" >&2
    exit 1
fi

echo "Formatting $DEVICE as ext4..."
mkfs.ext4 -F -L nas-storage "$DEVICE"

echo "Mounting at $MOUNT_POINT..."
mkdir -p "$MOUNT_POINT"
mount "$DEVICE" "$MOUNT_POINT"

UUID="$(blkid -s UUID -o value "$DEVICE")"
echo "Disk setup complete."
echo "To mount at boot, add this line to /etc/fstab:"
echo "  UUID=$UUID  $MOUNT_POINT  ext4  defaults,noatime,nofail  0  2"
