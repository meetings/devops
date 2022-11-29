/* Class: mysql
 *
 * 2014-07-11 / Meetin.gs
 */
class backup::mysql($dev_cron, $blog_cron, $main_cron) {
    realize Package['mysql-client']

    file {
        '/var/backups/databases':
            ensure  => directory,
            mode    => 0755;

        '/usr/local/bin/mysql_backup.sh':
            mode    => 0755,
            source  => 'puppet:///modules/backup/mysql_backup.sh';

        /* Template uses:
         *  $dev_cron
         *  $blog_cron
         *  $main_cron
         */
        '/etc/cron.d/mysql_backup':
            mode    => 0644,
            content => template('backup/mysql_backup.erb');
    }
}
