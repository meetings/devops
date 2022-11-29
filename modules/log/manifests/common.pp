/* Class: common
 *
 * Configure logging aspects common for each host.
 *
 * 2017-01-02 / Meetin.gs
 */
class log::common() {
    file { '/etc/rsyslog.conf':
        mode   => 0644,
        owner  => 'root',
        group  => 'root',
        source => 'puppet:///modules/log/rsyslog.conf',
        notify => Service['rsyslog'];
    }

    service { 'rsyslog':
        enable => true,
        ensure => running;
    }
}
