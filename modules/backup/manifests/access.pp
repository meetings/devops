/* Class: access
 *
 * 2014-07-11 / Meetin.gs
 */
class backup::access() {
    file {
        /* This should allow backup hosts to access related
         * machinae and run rsync(1) with sudo(8).
         */
        '/var/backups/.ssh':
            ensure => directory,
            mode   => 0700,
            owner  => 'backup',
            group  => 'backup';
        '/var/backups/.ssh/authorized_keys':
            mode   => 0644,
            owner  => 'backup',
            group  => 'backup',
            source => 'puppet:///modules/backup/authorized_keys';
        '/etc/sudoers.d/backup':
            mode   => 0440,
            source => 'puppet:///modules/backup/backup';
    }
}
