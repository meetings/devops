#!/bin/bash
# 2014-12-31 / Meetin.gs
# Backup database with mysqldump(1) to compressed file.
# Usage:
#  mysql_backup.sh <name> <port> [mysqldump options] [heuristic check?]

set -e

TAG=mysql

. /usr/local/lib/libmeetings.sh $TAG
. /usr/local/bin/publish_state.sh

syslog_everything $TAG

NAME=$1
PORT=$2

FILE=$(date -u "+%F-%H-%M-%S.db.xz")
PATH=$PATH:/usr/local/bin:/usr/local/sbin
OPTS=(-u root --all-databases --events --ignore-table=mysql.event)

[ -z "$NAME" ] && err "Missing 1st arg: src name"
[ -z "$PORT" ] && err "Missing 2nd arg: port number"

echo $$ Commencing database backup operations from $NAME
set_backup_to_pending $NAME

wait_for_lock && echo $$ Lock acquired

mkdir -p /var/backups/databases/$NAME/archive || errnotify "Unable to mkdir"
cd /var/backups/databases/$NAME || errnotify "Unable to chdir"

# Remove more than two months old database dumps except
# for those created on the 1st or 15th day of the month.
#
find -maxdepth 1 -type f -atime +62 \
  ! -name "????-??-01-??-??-??.db.*" \
  ! -name "????-??-15-??-??-??.db.*" -delete

# Dump dabatase, slow the process with pv,
# compress on the fly and write to file.
#
mysqldump -h 127.0.0.1 -P $PORT "${OPTS[@]}" ${3:-} | \
  pv -qL 2m | xz > $FILE || \
  errnotify "Database backup failed"

set_backup_to_done $NAME
echo $$ Database backup created

# If heuristic check is requested, try to determine, if
# database dump has failed, by checking that any newer
# dump is larger in size than older.
#
if [ -n "${4:-}" ]; then
  ls -1s *.db.xz | awk 'p >= $1 {print "failed? " $2; exit 1} {p = $1}'
  if [ $? != 0 ]; then
    set_backup_to_failed $NAME
    echo $$ Backup may have failed, please administer
  fi
fi

# Move backups from 1st or 15th day to archive.
#
find -maxdepth 1 -type f \
  -name "????-??-01-??-??-??.db.*" \
  -name "????-??-15-??-??-??.db.*" -exec mv {} archive \;
