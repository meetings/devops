/* Module: memcached
 *
 * 2015-02-06 / Meetin.gs
 */
class memcached($mem=192) {
    package {
        'memcached': ensure => installed
    }

    /* Template uses:
     *  $mem
     */
    file { '/etc/memcached.conf':
        mode    => 0644,
        content => template('memcached/memcached.conf.erb'),
        require => Package['memcached'];
    }
}
