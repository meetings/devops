/* Class: rsync
 *
 * 2014-07-28 / Meetin.gs
 */
class backup::rsync(
    $blog1_cron,
    $blog2_cron,
    $media1_cron,
    $media2_cron,
    $devdcp_cron
) {
    file {
        '/var/backups/rsync':
            ensure  => directory,
            mode    => 0755;

        '/usr/local/bin/rsync_snapshot.sh':
            mode    => 0755,
            source  => 'puppet:///modules/backup/rsync_snapshot.sh';

        /* Template uses:
         *  $blog1_cron
         *  $blog2_cron
         *  $media1_cron
         *  $media2_cron
         *  $devdcp_cron
         */
        '/etc/cron.d/rsync_snapshot':
            mode    => 0644,
            content => template('backup/rsync_snapshot.erb');
    }
}
