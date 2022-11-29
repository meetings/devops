#!/bin/bash
# 2014-07-28 / Meetin.gs
# Make snapshots with rsync(1)
# Usage: $0 [daily | weekly | monthly] <host> <src_dir>

set -u
set -e

TAG=rsync

. /usr/local/lib/libmeetings.sh $TAG
. /usr/local/bin/publish_state.sh

syslog_everything $TAG

TYPE=$1
HOST=$2
SRC=$3

PATH=$PATH:/usr/local/bin:/usr/local/sbin
OPTS=(-az --del --numeric-ids --bwlimit=2048 --rsync-path='sudo rsync')

[ -z "$TYPE" ] && err "Missing 1st arg: backup type"
[ -z "$HOST" ] && err "Missing 2nd arg: source host"
[ -z "$SRC"  ] && err "Missing 2rd arg: source path"

echo $$ Making $TYPE snapshot of data from $HOST:$SRC
set_backup_to_pending $HOST

wait_for_lock && echo $$ Lock acquired

DIR=$(basename $SRC)

[ -z "$DIR"  ] && err "Failed to parse short name"

mkdir -p /var/backups/rsync/$HOST/$TYPE || errnotify "Unable to mkdir"
cd /var/backups/rsync/$HOST/$TYPE || errnotify "Unable to chdir"

# Cycle old backups one step backward.
#
rm -rf $DIR.4 || err "Failed to remove old backup"
mv $DIR.3 $DIR.4 || true
mv $DIR.2 $DIR.3 || true
mv $DIR.1 $DIR.2 || true
mv $DIR.0 $DIR.1 || true

# If there are no old backups, create an empty directory
# to make rsync happy.
#
[ -d $DIR.1 ] || mkdir $DIR.1

# Make a smart rsync with hardlinking and using previous
# backup as starting point.
#
rsync "${OPTS[@]}" --link-dest=$PWD/$DIR.1 $HOST:$SRC $DIR.0
if [ $? != 0 ]; then
    set_backup_to_failed $HOST
    errnotify "rsync(1) quit with error $?"
fi

set_backup_to_done $HOST
echo $$ Snapshot ready
