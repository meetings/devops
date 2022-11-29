/* Module: managed
 *
 * This class defines the management slave.
 *
 * Create a framework to allow automatic management and
 * continuous integration consisting of the following:
 *
 * initdeploy - Deploy or update related service when
 *              machine is rebooted or when selected
 *              signal is received.
 *
 * githupdate - Update related service when selected
 *              signal is received.
 *
 * 2014-06-16 / Meetin.gs
 */
class managed(
    $auto=true,
    $intent=undef,
    $role='default',
    $rank=undef,
    $dir=undef,
    $url=undef
) {
    /* Failing to provide required parameters is syntax error.
     */
    if ! $intent {
        fail('Argument intent is required')
    }
    if ! $rank {
        fail('Argument rank is required')
    }
    if ! $url {
        fail('Argument url is required')
    }

    /* Add users Meetin.gs deployer and Meetin.gs manager
     * to access Github and to receive Upstart signals.
     */
    class { 'common::deployer': }
    class { 'managed::user': }

    file {
        /* Main configuration for autodeployment.
         *
         * Template uses:
         *  $intent
         *  $role
         *  $rank
         *  $dir
         *  $url
         */
        '/etc/autodeploy.conf':
            mode    => 0644,
            content => template('managed/autodeploy.conf.erb');

        /* Upstart configuration for initdeployment.
         *
         * Template uses:
         *  $auto
         */
        '/etc/init/initdeploy.conf':
            mode    => 0644,
            content => template('managed/initdeploy.conf.erb');

        /* Upstart configuration for githupdate process.
         */
        '/etc/init/githupdate.conf':
            mode   => 0644,
            source => 'puppet:///modules/managed/githupdate.conf';
    }
}
