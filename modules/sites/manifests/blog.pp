/* Class: blog
 *
 * Set up simple Apache configuration for Wordpress blog.
 *
 * 2014-09-24 / Meetin.gs
 */
class sites::blog() {
    $packages = [
        'php5',
        'apache2',
        'libapache2-mod-php5',
        'php5-mysql',
        'php5-curl',
        'php5-gd'
    ]

    package {
        $packages: ensure => installed
    }

    realize Package['mysql-client']

    file {
        '/etc/apache2/httpd.conf':
            mode    => 0644,
            source  => 'puppet:///modules/sites/httpd.conf',
            require => Package['apache2'];
        '/etc/apache2/ports.conf':
            mode    => 0644,
            source  => 'puppet:///modules/sites/ports.conf',
            require => Package['apache2'];
        '/etc/apache2/sites-available/default':
            mode    => 0644,
            source  => 'puppet:///modules/sites/blog_default',
            require => Package['apache2'];
        '/usr/local/sbin/meetings_sync_var_www.sh':
            mode    => 0755,
            source  => 'puppet:///modules/sites/meetings_sync_var_www.sh';
    }

    /* Change PHP configuration to allow >2M file uploads and
     * try to prevent Apache eating up all the available memory.
     */
    Augeas { require => Package['libapache2-mod-php5'] }
    augeas {
        'php_memory_limit':
            context => '/files/etc/php5/apache2/php.ini/PHP',
            changes => 'set memory_limit "256M"';
        'php_post_max':
            context => '/files/etc/php5/apache2/php.ini/PHP',
            changes => 'set post_max_size "250M"';
        'php_upload_max':
            context => '/files/etc/php5/apache2/php.ini/PHP',
            changes => 'set upload_max_filesize "250M"';

        'start_servers':
            context => "/files/etc/apache2/apache2.conf/*[arg = 'mpm_prefork_module']/directive[. = 'StartServers']",
            changes => 'set arg "15"';
        'min_spare_servers':
            context => "/files/etc/apache2/apache2.conf/*[arg = 'mpm_prefork_module']/directive[. = 'MinSpareServers']",
            changes => 'set arg "15"';
        'max_spare_servers':
            context => "/files/etc/apache2/apache2.conf/*[arg = 'mpm_prefork_module']/directive[. = 'MaxSpareServers']",
            changes => 'set arg "45"';
        'max_clients':
            context => "/files/etc/apache2/apache2.conf/*[arg = 'mpm_prefork_module']/directive[. = 'MaxClients']",
            changes => 'set arg "45"';
        'max_requests_per_child':
            context => "/files/etc/apache2/apache2.conf/*[arg = 'mpm_prefork_module']/directive[. = 'MaxRequestsPerChild']",
            changes => 'set arg "999"';
    }

    service { 'apache2':
        enable    => true,
        ensure    => running,
        subscribe => File[
            '/etc/apache2/httpd.conf',
            '/etc/apache2/ports.conf',
            '/etc/apache2/sites-available/default'
        ];
    }
}
