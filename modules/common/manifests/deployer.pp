/* Class: deployer
 *
 * Install Meetin.gs Deployer's identity
 * and configure a host alias for Github.
 *
 * 2014-07-11 / Meetin.gs
 */
class common::deployer() {
    File <| tag == 'root_ssh_directory' |>

    file {
        '/root/.ssh/config':
            mode    => 0644,
            owner   => 'root',
            group   => 'root',
            source  => 'puppet:///modules/common/deployer_config';
        '/root/.ssh/deployer':
            mode    => 0600,
            owner   => 'root',
            group   => 'root',
            source  => 'puppet:///modules/common/deployer';
        '/root/.ssh/deployer.pub':
            mode    => 0644,
            owner   => 'root',
            group   => 'root',
            source  => 'puppet:///modules/common/deployer.pub';
    }
}
