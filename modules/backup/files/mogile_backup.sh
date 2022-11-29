#!/bin/bash
# 2014-07-28 / Meetin.gs
# Back up files stored in MogileFS

set -e
set -u

TAG=mogile

. /usr/local/lib/libmeetings.sh $TAG
. /usr/local/bin/publish_state.sh

syslog_everything $TAG

HOST=$1

DATAROOT=/var/lib/mogstored/
PATH=$PATH:/usr/local/bin:/usr/local/sbin
OPTS=(-az --numeric-ids --bwlimit=2048 --rsync-path='sudo rsync')

[ -z "$HOST" ] && err "Missing 1st arg: source host"

echo $$ Backupping mogile files from $HOST
set_backup_to_pending $HOST

wait_for_lock && echo $$ Lock acquired

mkdir -p /var/backups/mogile/$HOST || errnotify "Unable to mkdir"
cd /var/backups/mogile/$HOST || errnotify "Unable to chdir"

rsync "${OPTS[@]}" $HOST:$DATAROOT .
if [ $? != 0 ]; then
    set_backup_to_failed $HOST
    errnotify "rsync(1) quit with error $?"
fi

set_backup_to_done $HOST
echo $$ Mogile backup done
