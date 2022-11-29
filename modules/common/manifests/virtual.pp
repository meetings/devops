/* Module: virtual
 *
 * Define a global set of virtual resources.
 *
 * 2016-10-22 / Meetin.gs
 */
class common::virtual() {
    @package {
        'mysql-client': ensure => installed
    }

    @file { '/root/.ssh':
        ensure => directory,
        mode   => 0700,
        owner  => 'root',
        group  => 'root',
        tag    => 'root_ssh_directory';
    }

    @file { '/etc/cron.d/restart_api':
        mode    => 0644,
        owner   => 'root',
        group   => 'root',
        content => template('common/restart_api.erb'),
        tag     => 'api_restart';
    }
}
