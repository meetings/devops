/* Class: common
 *
 * Configure common MariaDB server properties.
 *
 * 2016-11-11 / Meetin.gs
 */
class maria::common() {
    package {
        'mariadb-server': ensure => installed
    }

    file {
        /* FIXME Disable, because this might break Debian scripts
        '/etc/mysql/mariadb.conf.d/90-client-mariadb.cnf':
            mode    => 0644,
            owner   => 'root',
            group   => 'root',
            source  => 'puppet:///modules/maria/90-client-mariadb.cnf',
            require => Package['mariadb-server'];
        */

        '/etc/mysql/mariadb.conf.d/90-server.cnf':
            mode    => 0644,
            owner   => 'root',
            group   => 'root',
            source  => 'puppet:///modules/maria/90-server.cnf',
            require => Package['mariadb-server'];
    }
}
