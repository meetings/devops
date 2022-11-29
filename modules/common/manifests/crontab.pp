/* Define: crontab
 *
 * Add tasks to system crontab (i.e. /etc/crontab).
 *
 * Existence of identical command is checked and no duplicates
 * are added. Due the implementation, running the same command
 * at two different time specs is prohibited. Also, change in
 * time and/or user configuration does not alter existing cron
 * command. Unwanted cron commands need to be removed manually.
 *
 * 2013-02-16 / Meetin.gs
 */
define common::crontab(
    $minute,
    $hour,
    $dayofmonth,
    $month,
    $dayofweek,
    $user,
    $cmd
) {
    augeas { "${title}":
        context => '/files/etc/crontab',
        onlyif  => "match entry[. = '${cmd}'] size == 0",
        changes => [
            "set entry[last()+1]               '${cmd}'",
            "set entry[last()]/time            ''",
            "set entry[last()]/time/minute     '$minute'",
            "set entry[last()]/time/hour       '$hour'",
            "set entry[last()]/time/dayofmonth '$dayofmonth'",
            "set entry[last()]/time/month      '$month'",
            "set entry[last()]/time/dayofweek  '$dayofweek'",
            "set entry[last()]/user            '$user'"
        ];
    }
}
