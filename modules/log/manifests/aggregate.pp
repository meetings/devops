/* Class: aggregate
 *
 * Configure log aggregation host.
 *
 * 2016-11-16 / Meetin.gs
 */
class log::aggregate() {
    class {
        'log::common':;
    }

    file {
        '/etc/rsyslog.d/10-server.conf':
            mode   => 0644,
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/log/10-server.conf',
            notify => Service['rsyslog'];

        '/etc/rsyslog.d/55-meetings.conf':
            mode   => 0644,
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/log/55-meetings.conf',
            notify => Service['rsyslog'];
    }
}
