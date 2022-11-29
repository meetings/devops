#!/bin/bash
# 2014-09-26 / Meetin.gs
# Restart gearman-job-server if it has failed.

export PATH=$PATH:/sbin:/usr/sbin

wreak_havoc() {
    logger -t gearman -p daemon.err "gearman ${1}: wreaking havoc"
    service gearman-job-server stop
    pkill gearmand
    sleep 1
    pkill -9 gearmand
    sleep 1
    service gearman-job-server start
    exit 0
}

TMPF=$(mktemp)

timeout -k 2 2 gearadmin --status > $TMPF || wreak_havoc "hanged"

[ -s $TMPF ] || wreak_havoc "dead"

rm -f $TMPF

exit 0
