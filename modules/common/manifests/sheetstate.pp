/* Class: sheetstate
 *
 * Drop a script to push state of the
 * machine to Google spreadsheet.
 *
 * 2014-03-18 / Meetin.gs
 */
class common::sheetstate() {
    file { '/etc/cron.daily/sheetstate':
        mode   => 0755,
        owner  => 'root',
        group  => 'root',
        source => 'puppet:///modules/common/sheetstate';
    }
}
