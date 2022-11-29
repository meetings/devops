/* Module: common
 *
 * 2017-01-02 / Meetin.gs
 */
class common() {
    class {
        'common::clean':;
        'common::sheetstate':;
        'common::virtual':;
        #? 'common::touch';
    }

    /* Create a directory for Meetin.gs specific software.
     * Drop access key for The Keeper of Secrets.
     * Make alert scripts available.
     * Make shell script library available.
     */
    file {
        '/opt/meetings':
            ensure => directory,
            mode   => 0755;

        /*
        '/usr/local/bin/sms':
            mode   => 0755,
            source => 'puppet:///modules/common/sms';
        '/usr/local/bin/wrap':
            mode   => 0755,
            source => 'puppet:///modules/common/wrap';
        */

        '/usr/local/lib/libmeetings.sh':
            mode   => 0644,
            source => 'puppet:///modules/common/libmeetings.sh';
    }
}
