#!/bin/bash

VERSION=2014-03-04

say() {
    echo " +++ $@"
}

do_remote_call() {
    say Signalling port $1

    # Remote command is set in public key authorization options
    # on remote host. Thus the 'true' here is only a no-op.

    timeout -k 2 4 ssh -p $1 -i $IDENTITY -l $USER -o "$OPTION" $GATEWAY true || {
        say "Remote command failed for $1"
    }
}

say ${0##*/} version $VERSION

if [ -z "$1" ]; then
    echo "error: filter required"
    exit 1
fi

if [ $(id -u) -ne 0 ]; then
    echo "error: root privileges required"
    exit 1
fi

USER=manager
GATEWAY=gateway.dicole.com
OPTION="PasswordAuthentication no"
IDENTITY=/home/manager/.ssh/id_rsa
SERVICES=/etc/puppet/modules/ssh/files/pf/conf/provided_services.config

for FILTER in "$@"; do
    for PORT in $(grep -v '^#' $SERVICES | awk -vX="${FILTER}" '$0~X && $4==22 {print$1}'); do
        do_remote_call $PORT
    done
done

say "Ready"
