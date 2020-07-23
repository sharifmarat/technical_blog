---
Title: Using borgbackup with rsync.net
Date: 2020-07-23
Comments: true
Type: "post"
---

[rsync.net](https://rsync.net "visit rsync.net") offers cloud backups with ZFS snapshots.
It has very special pricing for borg accounts, as borg takes care of versioning automatically.

<!--more-->

[Special prices](https://www.rsync.net/products/borg.html "special prices for borg") start at 18 dollars per year for 100 GB.

### Initialize borg repo

Once you sign up, set up the key:

```shell
rsync -av ~/.ssh/id_rsa.pub account-name@sub.rsync.net:.ssh/authorized_keys 
```
Initialize the repo:

```shell
  borg init --remote-path=borg1 --encryption=keyfile ssh://account-name@sub.rsync.net/./path/to/backups
```

Option `--encryption=keyfile` will create a private key on the host machine. Borg will be using this key for symmetric encryption.
Don't forget to backup this key to somewhere else, otherwise you won't be able to extract your backups.

### Schedule backup jobs

Once the repo is ready, you can use the following script to start backups:
```shell
#!/bin/bash -ue

info() { printf "\n%s %s\n\n" "$( date )" "$*" >&1; }

backup() {
  : ${BORG:=borg}
  : ${PASS:=}
  local uri="$1"

  if [ -n "$PASS" ]; then
    export BORG_PASSPHRASE="$PASS"
  else
    unset BORG_PASSPHRASE
  fi

  local prunning="--keep-within 2d --keep-daily 7 --keep-weekly 4 --keep-monthly 3"
  local name=myserver
  local date=`date "+%F-%T"`

  info "Starting backup with $BORG to $uri"
  $BORG create                               \
    --verbose                                \
    --filter AME                             \
    --list                                   \
    --stats                                  \
    --show-rc                                \
    --compression lz4                        \
    --exclude-caches                         \
    --exclude '/dev/*'                       \
    --exclude '/home/*/.cache'               \
    --exclude '/lost+found/*'                \
    --exclude '/mnt/*'                       \
    --exclude '/media/*'                     \
    --exclude '/proc/*'                      \
    --exclude '/root/.cache'                 \
    --exclude '/run/*'                       \
    --exclude '/sys/*'                       \
    --exclude '/tmp/*'                       \
    --exclude '/var/cache'                   \
    --exclude '/var/lib/docker/devicemapper' \
    --exclude '/var/lock/*'                  \
    --exclude '/var/log/*'                   \
    --exclude '/var/run/*'                   \
    --exclude '/var/tmp/*'                   \
    --exclude '/var/backups/*'               \
    --exclude '/var/spool/*'                 \
   "$uri"::"$name-$date"                     \
    /

  info "Pruning repository"
  $BORG prune             \
      --list              \
      --prefix "$name-"   \
      --show-rc           \
      $prunning           \
      "$uri"
}


# backup to rsync.net
BORG="borg --remote-path=borg1" \
  backup "ssh://account-name@sub.rsync.net/./path/to/backups"

# backup to another server
# on this server passphrase is used instead of private key
PASS='example-passphrase' \
  backup "ssh://account-name@example.com/./path/to/backups"
```

Add to crontab to run it every 3 hours:

```shell
0  */3  *  *   * cronic flock -n /run/lock/backup.lock /path/to/backup-script.sh
```

### Adding mysql databases to backup

To dump mysql databases you can add the following addition to the script:

```shell
BACKUP_DIR=/path/to/mysql/backups

export MYSQL_PWD="backup-user-password"
mysqldump --all-databases --single-transaction --quick --lock-tables=false -u backup_user  > "$BACKUP_DIR"/$(date +%F-%T).bak

# Keep only 5 of latest dumps:
ls -t "$BACKUP_DIR"/*.bak | awk 'NR>5' | xargs rm -f

```

Don't forget to add `backup_user` and grant permissions to it:

```shell
GRANT LOCK TABLES, SELECT ON *.* TO 'backup_user'@'localhost IDENTIFIED BY 'backup-user-password';
flush privileges;
```
