/* Define: addwebhook
 *
 * Add a Github repository specific webhook for CI management.
 *
 * 2014-02-12 / Meetin.gs
 */
define managed::addwebhook($intent=$title, $filters=$title) {
    file {
        /* Template uses:
         *  $intent
         */
        "/etc/puppet/cgi/githupdate-${intent}":
            mode    => 0755,
            content => template('managed/githupdate-webhook.erb');

        /* Template uses:
         *  $intent
         *  $filters
         */
        "/etc/init/githupdate-${intent}.conf":
            mode    => 0644,
            content => template('managed/githupdate-intent.conf.erb'),
            require => File['/usr/local/sbin/githupdate.sh'];
    }
}
