/* Class: manager
 *
 * This class defines the manager master.
 *
 * Manager is a user and a script to receive Webhooks
 * and send upgrade signals to relevant hosts.
 *
 * 2013-06-04 / Meetin.gs
 */
class managed::manager() {
    class { 'managed::user': }

    file { '/usr/local/sbin/githupdate.sh':
        mode   => 0755,
        source => 'puppet:///modules/managed/githupdate.sh';
    }
}
