/* Module: common
 *
 * 2014-12-09 / Meetin.gs
 */
class backup() {
    File <| tag == 'root_ssh_directory' |>

    common::adduser {
        'git': comment => 'Git backup repository';
    }

    file {
        '/root/.ssh/config':
            mode   => 0644,
            source => 'puppet:///modules/backup/config';
        '/usr/local/bin/publish_state.sh':
            mode   => 0644,
            source => 'puppet:///modules/backup/publish_state.sh';
    }
}
