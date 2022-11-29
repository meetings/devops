/* Class: media
 *
 * Set up simple Apache configuration for static files.
 *
 * 2014-09-24 / Meetin.gs
 */
class sites::media() {
    package {
        'apache2': ensure => installed
    }

    file {
        '/etc/apache2/httpd.conf':
            mode    => 0644,
            source  => 'puppet:///modules/sites/httpd.conf',
            require => Package['apache2'];
        '/etc/apache2/sites-available/default':
            mode    => 0644,
            source  => 'puppet:///modules/sites/media_default',
            require => Package['apache2'];
        '/usr/local/sbin/meetings_sync_var_www.sh':
            mode    => 0755,
            source  => 'puppet:///modules/sites/meetings_sync_var_www.sh';
    }

    service { 'apache2':
        enable  => true,
        ensure  => running,
        require => Package['apache2'];
    }
}
