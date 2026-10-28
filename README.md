# Raspberry Pi Private NAS Server

A secure, lightweight Network Attached Storage (NAS) solution built using a Raspberry Pi 4 and OpenMediaVault. The system functions as a personal cloud server that provides secure file storage, remote access, and automated backups.

## Overview

This project transforms a Raspberry Pi into a private cloud storage system capable of:

- Secure file storage
- Remote web-based access
- Automated backups
- User permission management
- Network file sharing

The NAS system uses OpenMediaVault to manage storage services and integrates encryption to protect sensitive files.

## Features

- Private cloud file server
- Secure file access with user authentication
- Automated backup system
- Network sharing via SMB
- Encrypted storage support
- Web-based management dashboard

## Hardware Components

- Raspberry Pi 4
- External SSD (recommended 500GB+)
- USB 3.0 enclosure
- Ethernet connection
- Power supply

## Software Stack

- Raspberry Pi OS Lite
- OpenMediaVault
- Samba (SMB)
- rsync for backups
- LUKS disk encryption
- SSH remote access

## Installation Overview

1. Install Raspberry Pi OS Lite
2. Install OpenMediaVault
3. Configure storage and file systems
4. Configure SMB shares
5. Set up automated backups
6. Enable remote access

Full instructions are in [`1—Documentation/`](1—Documentation/README.md), starting with the
[installation guide](1—Documentation/installation-guide.md).

## Scripts

| Script | Purpose |
|---|---|
| [`scripts/encryption-setup.sh`](scripts/encryption-setup.sh) | LUKS2-encrypt, format and mount the data disk (recommended) |
| [`scripts/disk-setup.sh`](scripts/disk-setup.sh) | Format and mount an unencrypted data disk |
| [`scripts/backup-cron.sh`](scripts/backup-cron.sh) | Nightly rsync mirror to the backup disk, refusing to run unless both disks are mounted |

The setup scripts take the partition as an argument (e.g. `/dev/sda1`), refuse to
touch a mounted device, ask for confirmation before erasing, and print the
`/etc/fstab` / `/etc/crypttab` lines to persist the mount.

## Example Use Cases

- Personal cloud storage
- Media storage server
- Development backup server
- Secure document storage

## Future Improvements

- Nextcloud integration
- RAID storage configuration
- VPN remote access
- Automated monitoring and alerts
