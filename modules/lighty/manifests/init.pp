/* Module: lighty
 *
 * 2013-12-04 / Meetin.gs
 */
class lighty() {
    class { 'lighty::common':
        config => 'puppet:///modules/lighty/lighttpd.conf'
    }
}
