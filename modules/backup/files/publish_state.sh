#!/bin/bash

_update_backup_state() {
    curl "https://meetings-gapier.appspot.com/add_or_update_row" \
        --data-urlencode "worksheet_token=machinae:poceqarokeaslegy" \
        --data-urlencode "match_columns=Hostname" \
        --data-urlencode "match_values=$1" \
        --data-urlencode "set_columns=$(hostname)" \
        --data-urlencode "set_values=$2" &>/dev/null
}

set_backup_to_failed() {
    _update_backup_state $1 "failed"
}

set_backup_to_pending() {
    _update_backup_state $1 "pending"
}

set_backup_to_done() {
    _update_backup_state $1 "$(date +%F)"
}
