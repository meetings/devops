/* Module: maria
 *
 * Simple MariaDB configuration without
 * any resiliency or redundancy.
 *
 * 2016-11-09 / Meetin.gs
 */
class maria() {
    class { 'maria::common': }
}
