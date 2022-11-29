/* Module: log
 *
 * Configuration to send log data to aggregation hosts.
 *
 * 2016-11-16 / Meetin.gs
 */
class log($aggregation_addr=[]) {
    class {
        'log::common':;
    }

    file { '/etc/rsyslog.d/10-client.conf':
        mode    => 0644,
        owner   => 'root',
        group   => 'root',
        content => template('log/10-client.conf.erb'),
        notify  => Service['rsyslog'];
    }
}
