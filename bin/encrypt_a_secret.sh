#!/bin/bash
# encrypt_a_secret.sh, 2014-04-14 / Meetin.gs

SSH_CONNECTION="-p 11122 gateway.dicole.com"

if [ -z "$1" ]; then
    echo "Usage:"
    echo " ${0##*/} <recipient>"
    echo " -- Read message from stdin, encrypt it with"
    echo "    recipients key and write to stdout."
    echo " ${0##*/} list"
    echo " -- List available recipient keys."
    exit 0
elif [ "$1" == "list" ]; then
    ssh $SSH_CONNECTION sudo gpg --homedir /run/gpg -k 2> /dev/null
    exit 0
fi

cat | ssh $SSH_CONNECTION sudo gpg --homedir /run/gpg -ae --default-recipient "$1" 2> /dev/null
