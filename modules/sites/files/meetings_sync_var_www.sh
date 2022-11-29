#!/bin/sh

if [ -z "$1" ]; then
    echo error: $0: target hostname required
    exit 1
fi

rsync -ae ssh -B 8192 --del ${1}:/var/www/ /var/www/
