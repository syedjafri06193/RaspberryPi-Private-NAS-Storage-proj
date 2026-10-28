# Automated Backup System

Backups are automated using rsync and cron jobs.

The system performs:

- Incremental backups
- Daily scheduled synchronization
- Backup verification

Example backup schedule:

Daily Backup
2:00 AM every day

Cron entry (as root):

```
0 2 * * * /opt/nas/scripts/backup-cron.sh >> /var/log/nas-backup.log 2>&1
```

`scripts/backup-cron.sh` mirrors `/mnt/nas-storage/` to `/mnt/nas-backup/`
with `rsync -aH --delete`. Before copying it checks that **both** paths are
mounted file systems: if the backup disk were unplugged, rsync would fill the
SD card; if the data disk were missing, `--delete` would empty the backup to
match. A lock file prevents overlapping runs. Override the paths with the
`SOURCE` and `DEST` environment variables.
