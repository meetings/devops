/* Module: nag
 *
 * 2014-07-31 / Meetin.gs
 */
class nag() {
    common::addsecret {
        'nag.conf': path => '/etc/nag.conf';
    }

    file {
        '/etc/cron.d/nagnag':
            mode   => 0644,
            source => 'puppet:///modules/nag/nagnag.cron';
        '/usr/local/bin/nagnag.sh':
            mode   => 0755,
            source => 'puppet:///modules/nag/nagnag.sh';
    }
}
