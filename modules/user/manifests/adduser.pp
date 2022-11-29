/* Define: adduser
 *
 * Create a user account. Optionally, account
 * is elevated to superuser privileges.
 *
 * Account is accessible by public key authentication.
 * Public key may restrict the usage of the account.
 *
 * Always include users public key in
 * files/authorized_keys/${user}.pub.
 *
 * 2014-04-23 / Meetin.gs
 */
define user::adduser($user=$title, $comment, $groups=[], $super=false) {
    user { "${user}":
        ensure     => present,
        comment    => "${comment}",
        gid        => 'users',
        groups     => $groups,
        home       => "/home/${user}",
        managehome => true,
        shell      => '/bin/bash';
    }

    user::authkey {
        "${user}": require => User["${user}"];
    }

    if $super {
        /* Template uses:
         *  $user
         */
        file { "/etc/sudoers.d/${user}":
            ensure  => present,
            mode    => 0440,
            owner   => 'root',
            group   => 'root',
            content => template('user/sudoers.erb');
        }
    }
}
