/* Class: tuomas
 *
 * 2014-12-31 / Meetin.gs
 */
class user::tuomas() {
    file { '/home/tuomas':
        ensure  => directory,
        owner   => 'tuomas',
        group   => 'users',
        recurse => true,
        source  => 'puppet:///modules/user/tuomas';
    }
}
