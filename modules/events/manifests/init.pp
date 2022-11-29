/* Module: events
 *
 * 2014-10-06 / Meetin.gs
 */
class events($peer_url=false) {
    $packages = [
        'libanyevent-http-perl',
        'libdata-dump-perl',
        'libjson-perl',
        'libset-object-perl',
        'libuuid-tiny-perl',
        'twiggy'
    ]

    package {
        $packages: ensure => installed
    }

    /* Template uses:
     *  $peer_url
     */
    file { '/etc/dicole-events.conf':
        mode    => 0644,
        content => template('events/dicole-events.conf.erb');
    }

    package {
        'dicole-events': ensure => latest
    }
}
