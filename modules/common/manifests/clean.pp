/* Class: clean
 *
 * Remove fossilized and stale objects.
 *
 * 2016-10-22 / Meetin.gs
 */
class common::clean() {
    file {
        /* There are no optical drives.
         */
        '/media/cdrom':
            ensure  => absent,
            force   => true;

        /* Lighty logs should go to /var/log/lighty and
         * this should be useless default directory.
         */
        # FIXME Is lighty used anymore?
        '/etc/logrotate.d/lighttpd':
            ensure  => absent;
        '/var/log/lighttpd':
            ensure  => absent,
            recurse => true,
            force   => true;
    }
}
