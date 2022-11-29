/* Module: nodejs
 *
 * 2014-09-29 / Meetin.gs
 */
class nodejs() {
    package {
        ['npm', 'nodejs', 'nodejs-legacy']: ensure => installed
    }
}
