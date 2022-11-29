/* Class: mogile
 *
 * 2014-07-11 / Meetin.gs
 */
class backup::mogile($dev1_cron, $dev2_cron, $live1_cron, $live2_cron) {
    file {
        '/var/backups/mogile':
            ensure  => directory,
            mode    => 0755;

        '/usr/local/bin/mogile_backup.sh':
            mode    => 0755,
            source  => 'puppet:///modules/backup/mogile_backup.sh';

        /* Template uses:
         *  $dev1_cron
         *  $dev2_cron
         *  $live1_cron
         *  $live2_cron
         */
        '/etc/cron.d/mogile_backup':
            mode    => 0644,
            content => template('backup/mogile_backup.erb');
    }
}
