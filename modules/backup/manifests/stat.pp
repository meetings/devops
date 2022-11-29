/* Class: stat
 *
 * Enable statistics user to fetch most recent data-
 * base dump (to allow generating some statistics).
 *
 * 2014-04-23 / Meetin.gs
 */
class backup::stat() {
    common::adduser {
        'stat': comment => 'Meetin.gs statistic';
    }

    file { '/usr/local/bin/dump_latest_dump.sh':
        mode   => 0755,
        source => 'puppet:///modules/backup/dump_latest_dump.sh';
    }
}
