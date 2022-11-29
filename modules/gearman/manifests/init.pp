/* Module: gearman
 *
 * 2015-02-09 / Meetin.gs
 */
class gearman() {
    class {
        'gearman::watchdog':;
    }

    package {
        'gearman': ensure => installed;
    }

    file {
        '/etc/default/memcached':
            mode   => 0644,
            source => 'puppet:///modules/gearman/memcached';
        '/etc/default/gearman-job-server':
            mode   => 0644,
            source => 'puppet:///modules/gearman/gearman-job-server';
    }
}
