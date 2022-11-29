/* Module: puppet
 *
 * 2016-10-22 / Meetin.gs
 */
class puppet() {
    /* Configure Github Webhooks and package repository,
     * and allow Webhooks to do superuser stuff.
     */
    file {
        '/etc/apache2/sites-available/default':
            mode   => 0644,
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/puppet/default-site';
        '/etc/sudoers.d/www-data':
            mode   => 0440,
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/puppet/www-data';
    }
}
