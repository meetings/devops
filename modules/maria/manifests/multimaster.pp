/* Class: multimaster
 *
 * Multi-master MariaDB setup.
 *
 * 2016-11-12 / Meetin.gs
 */
class maria::multimaster(
    $server_id=undef,
    $auto_increment=undef,
    $inc_offset=undef,
    $binlog_expire=7
) {
    class { 'maria::common': }

    file {
        /* Template uses:
         *  $server_id
         *  $auto_increment
         *  $inc_offset
         *  $binlog_expire
         */
        '/etc/mysql/mariadb.conf.d/90-multi-master.cnf':
            mode    => 0644,
            owner   => 'root',
            group   => 'root',
            content => template('maria/90-multi-master.cnf.erb'),
            require => Package['mariadb-server'];
    }

    service { 'mysql':
        enable    => true,
        ensure    => running,
        subscribe => File['/etc/mysql/mariadb.conf.d/90-multi-master.cnf'];
    }
}
