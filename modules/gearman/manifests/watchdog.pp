/* Class: watchdog
 *
 * Monitor gearmand(8) and kick it hard if it seems to have failed.
 *
 * 2014-01-09 / Meetin.gs
 */
class gearman::watchdog() {
    file { '/usr/local/sbin/gearman-force-fix.sh':
        mode   => 0755,
        source => 'puppet:///modules/gearman/gearman-force-fix.sh';
    }

    cron { 'forcefix':
        minute   => '*/2',
        hour     => '*',
        monthday => '*',
        month    => '*',
        weekday  => '*',
        user     => 'root',
        command  => '/usr/local/sbin/gearman-force-fix.sh',
        require  => File['/usr/local/sbin/gearman-force-fix.sh'];
    }
}
