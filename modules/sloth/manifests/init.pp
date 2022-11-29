/* Module: sloth
 *
 * 2015-02-10 / Meetin.gs
 */
class sloth($config) {
    package {
        ['gearsloth', 'sqlite3']: ensure => installed
    }

    file {
        '/etc/default/gearsloth':
            mode    => 0644,
            source  => 'puppet:///modules/sloth/default',
            require => Package['gearsloth'];

        '/etc/gearsloth/gearsloth.json':
            mode    => 0644,
            source  => "puppet:///modules/sloth/${config}.json",
            require => Package['gearsloth'];
    }
}
