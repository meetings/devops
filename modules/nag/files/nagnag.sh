#!/bin/bash

. /usr/local/lib/libmeetings.sh nagnag

syslog_everything nagnag
impatient_lock || exit 0

pkill -0 nodejs && exit 0
echo $$ Nag not found

sleep 100

pkill -0 nodejs && exit 0
echo $$ Nag not found, sending notification
nma "404 Nag not found"
