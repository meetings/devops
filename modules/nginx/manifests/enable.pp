/* Define: enable
 *
 * 2015-08-23 / Meetin.gs
 */
define nginx::enable($domain=$title, $ensure='link') {
    file { "/etc/nginx/sites-enabled/${domain}":
        ensure => $ensure,
        target => "/etc/nginx/sites-available/${domain}",
        notify => Service['nginx'];
    }
}
