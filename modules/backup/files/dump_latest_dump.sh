#!/bin/bash
# 2014-07-09 / Meetin.gs
# Find the most recent production database
# backup dump and print it to stdout.

cd /var/backups/databases/mm-mysql-6 || exit 1

cat $(ls -c *.db.xz | head -n1)
