/* Class: users
 *
 * Add administrative user account with public key
 * authentication and permission to to anything
 * with sudo(8).
 *
 * 2014-12-31 / Meetin.gs
 */
class user() {
    user::adduser {
        'amv':
            comment => 'Antti Vähäkotamäki',
            groups  => ['adm'],
            super   => true;
        'tuomas':
            comment => 'Tuomas Starck',
            groups  => ['adm', 'crontab'],
            super   => true;
    }

    file { '/etc/sudoers':
        ensure => present,
        mode   => 0440,
        owner  => 'root',
        group  => 'root',
        source => 'puppet:///modules/user/sudoers';
    }

    class {
        'user::tuomas': require => User['tuomas'];
    }
}
