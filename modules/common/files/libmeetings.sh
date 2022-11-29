#!/bin/bash
# 2014-12-09 / Meetin.gs
# A library of common useful shell script routines
# Usage:
#  . libmeetings.sh $NAME    -- If NAME is given, locking is prepared,
#                               otherwise lock functions do not work
#                               and should not be used.
#  wait_for_lock             -- Blocks until lock is acquired
#  impatient_lock || exit 1  -- Errors if lock is not acquired immediately
#  syslog_everything $TAG    -- Redirect stdout and stderr to syslog
#  sheet_update $COL $VAL    -- Update a column in sheet
#  nma $@                    -- Send a notification
#  err $@                    -- Print error and exit 1
#  errnotify $@              -- Send notification, print and exit 1

set -u

LOCKFD=9
LOCKFILE=/var/lock/default.lock

# http://stackoverflow.com/a/1985512
_release_lock() { flock -u $LOCKFD; flock -xn $LOCKFD && rm -f $LOCKFILE; }
_prepare_lock() { eval "exec $LOCKFD> $LOCKFILE"; trap _release_lock EXIT; }

_urlencode() {
  # https://gist.github.com/cdown/1163649
  local length="${#1}"
  for (( i = 0; i < length; i++ )); do
    local c="${1:i:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf "$c" ;;
      *) printf '%%%02X' "'$c"
    esac
  done
}

_nma() {
  REQ="https://www.notifymyandroid.com/publicapi/notify"
  REQ+="?apikey=e7140ce1d0b3d7cdc04e6d38b54ea2ee5e003b83d978c909"
  REQ+="&application=$(hostname)"
  REQ+="&event=${1:-empty}"
  REQ+="&description=${2:-empty}"
  curl -s -m 12 -o /dev/null "${REQ}"
}

# $@: message
#
nma() { MSG=$(_urlencode "$@"); _nma "${0##*/}" "$MSG"; }
errnotify() { nma "$@"; err "$@"; }
err() { echo " *** $@"; exit 1; }

# Acquire exclusive lock either with or without waiting.
#
wait_for_lock()  { flock -x  $LOCKFD; }
impatient_lock() { flock -xn $LOCKFD; }

# Redirect stdout and stderr to syslog.
#
syslog_everything() {
  TAG=${1:-meetings}
  FIFO=`mktemp --dry-run`
  mkfifo $FIFO
  (logger -t "$TAG" -p local0.info <$FIFO &)
  exec 2> $FIFO
  exec > $FIFO
  rm $FIFO
}

# $1: required column
# $2: optional value
#
sheet_update() {
  [ -z "${1:-}" ] && return
  curl "https://meetings-gapier.appspot.com/add_or_update_row" \
    --data-urlencode "worksheet_token=machinae:poceqarokeaslegy" \
    --data-urlencode "match_columns=Hostname" \
    --data-urlencode "match_values=$(hostname)" \
    --data-urlencode "set_columns=${1}" \
    --data-urlencode "set_values=${2:-}" &>/dev/null
}

# Prepare and enable locking, if name is given.
#
if [ -n "${1:-}" ]; then
  LOCKFILE=/var/lock/${1}.lock
  _prepare_lock
fi
