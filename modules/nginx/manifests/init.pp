/* Module: nginx
 *
 * 2016-12-05 / Meetin.gs
 */
class nginx() {
    file {
        '/etc/nginx/nginx.conf':
            mode    => 0644,
            content => template('nginx/nginx.conf.erb'),
            notify  => Service['nginx'];

        '/etc/nginx/conf.d/ssl.conf':
            mode    => 0644,
            source  => 'puppet:///modules/nginx/ssl.conf',
            notify  => Service['nginx'];

        '/etc/nginx/sites-enabled/default':
            ensure  => absent;

        '/etc/nginx/sites-available':
            ensure  => directory,
            recurse => true,
            purge   => true,
            source  => 'puppet:///modules/nginx/sites';
    }

    nginx::enable {
        '000-beta-http-core-pool':;
        '000-dcp-core-pool':;
        '000-live-http-core-pool':;
        '000-pools':;
        'api-meetings-sites':;
        'beta-dicolenet-sites':;
        'beta-meetings-sites':;
        'blogging-sites':;
        'cuty-service':;
        'default-proxy':;
        'dev-dicolenet-sites':;
        'dev-meetings-sites':;
        'dicole.net':;
        'events-service':;
        'live-blog-sites':;
        'media.dicole.com':;
        'meetin.gs':;
        'platform-meetings-sites':;
        'puppetmaster.dicole.net':;
        'track-meetings-sites':;
        'ubuntu.meetin.gs':;
        'urlcache.meetin.gs':;
        'web-sites':;
        'xxx-dicolenet-catchall':;
        'xxx-meetings-catchall':;
    }

    service { 'nginx':
        ensure     => running,
        enable     => true,
        hasrestart => true;
    }
}
