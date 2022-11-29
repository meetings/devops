/* Module: mogile
 *
 * 2014-10-06 / Meetin.gs
 */
class mogile($trackers=undef) {
    realize Package['mysql-client']

    $packages = [
        'mogilefsd',
        'mogstored',
        'mogilefs-utils',
        'libmogilefs-perl'
    ]

    package {
        $packages: ensure => installed
    }

    if $trackers {
        file { '/etc/mogilefs/mogilefs.conf':
            mode    => 0644,
            content => template('mogile/mogilefs.conf.erb'),
            require => Package['mogilefsd', 'mogstored'];
        }
    }

    file {
        '/etc/default/mogilefsd':
            mode    => 0644,
            source  => 'puppet:///modules/mogile/mogilefsd',
            require => Package['mogilefsd'];
        '/etc/default/mogstored':
            mode    => 0644,
            source  => 'puppet:///modules/mogile/mogstored',
            require => Package['mogstored'];

        '/etc/mogilefs/mogilefsd.conf':
            mode    => 0644,
            source  => 'puppet:///modules/mogile/mogilefsd.conf',
            require => Package['mogilefsd'];
        '/etc/mogilefs/mogstored.conf':
            mode    => 0644,
            source  => 'puppet:///modules/mogile/mogstored.conf',
            require => Package['mogstored'];

        ['/var/lib/mogstored',
         '/var/lib/mogstored/dev1',
         '/var/lib/mogstored/dev2']:
            ensure  => directory,
            mode    => 0755,
            owner   => 'mogstored',
            require => Package['mogstored'];
    }

    service {
        'mogilefsd':
            enable  => true,
            ensure  => running,
            require => File['/etc/mogilefs/mogilefsd.conf'];
        'mogstored':
            enable  => true,
            ensure  => running,
            require => File['/etc/mogilefs/mogstored.conf'];
    }
}
