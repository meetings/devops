/* Class: files
 *
 * Create the expected directory structure
 * and drop some configurations.
 *
 * 2015-08-16 / Meetin.gs
 */
class dcp::files($flavor, $restart_time=undef) {
    /* Currently, secret server.ini is overwritten when
     * secret changes.
     *
     * Better would be to call a script, which updates
     * the static_file_version after the puppet run.
     */
    case $flavor {
        'live', 'beta': {
            file { '/etc/post_decrypt_hooks.d/server_ini_post_decrypt_hook':
                mode   => 0755,
                source => 'puppet:///modules/dcp/server_ini_post_decrypt_hook';
            }
            common::addsecret { "${flavor}_server.ini":
                path    => '/usr/local/dcp/conf/server.ini',
                require => File['/usr/local/dcp/conf'];
            }
        }
        default: {
            file { '/usr/local/dcp/conf/server.ini':
                mode    => 0644,
                replace => false,
                source  => "puppet:///modules/dcp/_${flavor}/conf/server.ini";
            }
        }
    }

    file {
        ['/usr/local/dcp',
         '/usr/local/dcp/cache',
         '/usr/local/dcp/cache/tt',
         '/usr/local/dcp/logs']:
            ensure => directory,
            mode   => 0755,
            owner  => 'www-data',
            group  => 'www-data';

        ['/usr/local/dcp/cgi-bin',
         '/usr/local/dcp/msg',
         '/usr/local/dcp/pkg']:
            ensure => directory,
            mode   => 0755;

        '/usr/local/dcp/conf':
            ensure  => directory,
            recurse => true,
            replace => true,
            purge   => false,
            source  => "puppet:///modules/dcp/_${flavor}/conf";

        '/usr/local/dcp/cgi-bin/oi2.fcgi':
            mode   => 0755,
            source => "puppet:///modules/dcp/_${flavor}/cgi-bin/oi2.fcgi";

        '/usr/local/bin/run_logging_workers.sh':
            mode   => 0755,
            source => 'puppet:///modules/dcp/run_logging_workers.sh';
        '/usr/local/bin/restart_lighttpd.sh':
            mode   => 0755,
            source => 'puppet:///modules/dcp/restart_lighttpd.sh';

        '/root/.bash_aliases':
            mode   => 0644,
            source => "puppet:///modules/dcp/_${flavor}/bash_aliases";
    }

    /* Virtual resources for restarting services or workers.
     */
    @file {
        '/etc/cron.d/meetings_workers':
            mode    => 0644,
            source  => "puppet:///modules/dcp/_${flavor}/meetings_workers",
            tag     => 'restart_workers';

        /* Template uses:
         *  $restart_time
         */
        '/etc/cron.d/meetings_services':
            mode    => 0644,
            content => template('dcp/meetings_services.erb'),
            tag     => 'restart_services';
    }
}
