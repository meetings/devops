/* Module: varnish
 *
 * Install and configure Varnish http accelerator.
 *
 * 2014-01-11 / Meetin.gs
 */
class varnish($flavor) {
    file {
        '/etc/default/varnish':
            mode    => 0644,
            source  => "puppet:///modules/varnish/default_${flavor}";

        '/etc/varnish/default.vcl':
            mode    => 0644,
            source  => "puppet:///modules/varnish/vcl_${flavor}";
    }

    exec {
        'generate_secret':
            command     => '/usr/bin/uuidgen > /etc/varnish/secret',
            creates     => '/etc/varnish/secret',
            notify      => Exec['hide_secret'];

        'hide_secret':
            command     => '/bin/chmod 400 /etc/varnish/secret',
            refreshonly => true;
    }

    service { 'varnish':
        enable    => true,
        ensure    => running,
        subscribe => File[
            '/etc/default/varnish',
            '/etc/varnish/default.vcl'
        ];
    }
}
