#!/usr/bin/env bash
# Mirror the NAS data disk to the backup disk. Intended for cron, e.g.
#   0 2 * * * /opt/nas/scripts/backup-cron.sh >> /var/log/nas-backup.log 2>&1
#
#   SOURCE / DEST can be overridden with environment variables.
set -euo pipefail

SOURCE="${SOURCE:-/mnt/nas-storage}"
DEST="${DEST:-/mnt/nas-backup}"
LOCK="${LOCK:-/run/nas-backup.lock}"

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') $*"; }

# Both sides must be real mounts. If the backup disk is unplugged, rsync would
# otherwise fill the SD card under $DEST; if the data disk is missing,
# --delete would wipe the backup to match an empty directory.
for dir in "$SOURCE" "$DEST"; do
    if ! mountpoint -q "$dir"; then
        log "ERROR: $dir is not a mounted file system; backup skipped"
        exit 1
    fi
done

# Never run two backups at once (a slow run overlapping the next cron slot).
exec 9>"$LOCK"
if ! flock -n 9; then
    log "another backup is still running; skipping"
    exit 0
fi

log "backup started: $SOURCE -> $DEST"
# Trailing slash on SOURCE: copy its contents, not the directory itself.
rsync -aH --delete --stats "$SOURCE/" "$DEST/"
log "backup finished"
