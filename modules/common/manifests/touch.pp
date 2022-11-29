/* Class: touch
 *
 * Record the date, when puppet(8) was last run.
 *
 * 2015-03-31 / Meetin.gs
 */
class common::touch() {
    exec {
        'lastrun':
            command => 'date +%F | tee /etc/puppet/lastrun',
            path    => ['/bin', '/usr/bin'],
            before  => Exec['sheeet'];

        'sheeet':
            command => '/etc/cron.daily/sheetstate',
            onlyif  => 'test -f /etc/cron.daily/sheetstate',
            path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'];
    }
}
