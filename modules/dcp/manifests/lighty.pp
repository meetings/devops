/* Class: lighty
 *
 * 2015-04-20 / Meetin.gs
 */
class dcp::lighty($flavor) {
    class { 'lighty::common':
        config => "puppet:///modules/dcp/_${flavor}/lighty/lighttpd.conf";
    }

    file {
        '/usr/local/dcp/html':
            ensure  => directory,
            mode    => 0755,
            owner   => 'www-data',
            group   => 'www-data',
            before  => File['/etc/lighttpd/lighttpd.conf'];

        '/etc/lighttpd/conf-available/10-fastcgi.conf':
            mode    => 0644,
            source  => "puppet:///modules/dcp/_${flavor}/lighty/10-fastcgi.conf",
            require => Package['lighttpd'];
        '/etc/lighttpd/conf-enabled/10-fastcgi.conf':
            ensure  => link,
            target  => '../conf-available/10-fastcgi.conf',
            require => Package['lighttpd'];

        '/etc/lighttpd/dcp-fcgi-generate.pl':
            mode    => 0755,
            source  => "puppet:///modules/dcp/_${flavor}/lighty/dcp-fcgi-generate.pl",
            require => Package['lighttpd'];
        '/etc/lighttpd/dcp-fcgi.tmpl':
            mode    => 0644,
            source  => "puppet:///modules/dcp/_${flavor}/lighty/dcp-fcgi.tmpl",
            require => Package['lighttpd'];
    }

    /* A virtual symlink, which should be
     * realized on localdev configuration.
     */
    @file { '/var/www/local.meetin.gs':
        ensure => link,
        target => '/usr/local/dcp/html',
        tag    => 'localdev';
    }
}
