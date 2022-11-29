/* Class: common
 *
 * A set of common properties in lighttpd setup.
 *
 * 2014-04-13 / Meetin.gs
 */
class lighty::common($config) {
    package { 'lighttpd': ensure => installed }

    file {
        '/etc/lighttpd/lighttpd.conf':
            mode    => 0644,
            source  => $config,
            require => Package['lighttpd'];

        '/var/log/lighty':
            ensure  => directory,
            mode    => 0755,
            owner   => 'syslog',
            group   => 'adm';
    }

    service { 'lighttpd':
        enable    => true,
        ensure    => running,
        subscribe => File['/etc/lighttpd/lighttpd.conf'];
    }
}
