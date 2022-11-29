/*\ site.pp, Meetin.gs node definitions
\*/

/*\  DEFAULT FOR ALL
\*/
node default {
    class {
        'log':;
        'user':;
        'common':;
    }
}

/*\  VIRTHOSTS
\*/
node "savu.dicole.com", "pilvi.dicole.com" {
    class {
        #? 'log':;
        'user':;
        #? 'common':;
    }
}

/*\  PUPPET
\*/
node "puppet.meetin.gs" {
    class {
        'log':;
        'user':;
        'common':;
    }
}

/*\  LOG
\*/
node "log-1.meetin.gs", "log-2.meetin.gs" {
    class {
        'user':;
        'common':;
        'log::aggregate':;
    }
}

/*\  MARIADB
 *
 *  Parameters:
 *  server_id        Mysql instance server-id.
 *  auto_increment   The number of servers in replication pool.
 *  inc_offset       Unique offset of each server in the pool.
 *  binlog_expire    Optional. Binlog expiry time in days.
 *  FIXME slave_check_min  If given, replication status is checked.
 *                   Value is used as such in cron(8) minute
 *                   specification.
\*/
node "maria-1.meetin.gs" {
    class {
        'log':;
        'user':;
        'common':;
        'maria::multimaster':;
    }
}
node "maria-2.meetin.gs" {
    class {
        'log':;
        'user':;
        'common':;
        'maria::multimaster':;
    }
}

/*\  FRONT
\*/
node "front-1.meetin.gs" {
    /* File <| tag == 'log_nginx' |>
       File <| tag == 'log_slave' |> */

    class {
        'log':;
        'user':;
        'common':;

        'nginx':;
        'perlbal': flavor => 'live';
        'varnish': flavor => 'live';
    }
}



/*\  !!!  DEPRECATION WARNING  !!!
 *   !!!   DRAGONS BELOW THIS  !!!
\*/

/*\  domU CLASSES
 *
 *  FIXME Node inheritance has been deprecated in puppet 3.8 :-(
\*/
node domU inherits default {
    File <| tag == 'log_slave' |>
}
node testU inherits default {
    File <| tag == 'log_slave' |>
}
node nodenode inherits domU {
    class { 'nodejs': }
}
node testnode inherits testU {
    class { 'nodejs': }
}

/*\  PUPPET
 *
 *  Puppet acts as puppetmaster and continuous integration hub.
 *
 *  FIXME Webhooks takes an optional argument 'filters' which
 *  is a string list of filters, which should be used instead
 *  of webhook title.
\*/
node "puppet.mtn.gs" inherits domU {
    class {
        'log':;
        'puppet':;
        'managed::manager':;
    }

    /*
    managed::addwebhook {
        'api':;
        'core': filters => 'beta-worker-core miner';
        'cuty':;
        'front':;
        'nag': filters => 'nag-1';
        'stats':;
        'urlcache':;
        'web':;
        'worker-js':;
    }
    */
}

/*\  DC1
\*/
/*
node jojo inherits default {
    class {
        'dom0':;
        'network::dom0':
            ipv6      => '2a01:4f8:a0:93af::2',
            ip        => '213.239.211.12',
            netmask   => '255.255.255.224',
            broadcast => '213.239.211.31',
            gateway   => '213.239.211.1',
            subnet    => '213.239.211.0/27';
    }
}
*/
/*
node kivi inherits default {
    class {
        'dom0':;
        'network::dom0':
            ipv6      => '2a01:4f8:a0:8190::2',
            ip        => '213.239.214.130',
            netmask   => '255.255.255.224',
            broadcast => '213.239.214.159',
            gateway   => '213.239.214.129',
            subnet    => '213.239.214.128/27';
    }
}
*/

/*\  DC19
\*/
/*
node yrtti inherits default {
    class { 'dom0': }
    class { 'network::dom0':
        ipv6      => '2a01:4f8:192:1163::2',
        ip        => '144.76.84.100',
        netmask   => '255.255.255.224',
        broadcast => '144.76.84.127',
        gateway   => '144.76.84.97',
        subnet    => '144.76.84.96/27';
    }
}
*/
/*
node ruoho inherits default {
    class { 'dom0': }
    class { 'network::dom0':
        ipv6      => '2a01:4f8:192:1292::2',
        ip        => '144.76.85.147',
        netmask   => '255.255.255.224',
        broadcast => '144.76.85.159',
        gateway   => '144.76.85.129',
        subnet    => '144.76.85.128/27';
    }
}
*/

/*\  DC16
\*/
/*
node keksi inherits default {
    class { 'dom0': }
    class { 'network::dom0':
        ipv6      => '2a01:4f8:161:30c6::2',
        ip        => '5.9.41.212',
        netmask   => '255.255.255.224',
        broadcast => '5.9.41.223',
        gateway   => '5.9.41.193',
        subnet    => '5.9.41.192/27';
    }
}
*/
/*
node myssy inherits default {
    class { 'dom0': }
    class { 'network::dom0':
        ipv6      => '2a01:4f8:161:30c7::2',
        ip        => '5.9.41.213',
        netmask   => '255.255.255.224',
        broadcast => '5.9.41.223',
        gateway   => '5.9.41.193',
        subnet    => '5.9.41.192/27';
    }
}
*/

/*\  DC14
\*/
/*
node savu inherits default {
    class {
        'dom0':
            dom0_mem  => '2048';
        'network::dom0':
            ipv6      => '2a01:4f8:140:32ea::2',
            ip        => '46.4.71.238',
            netmask   => '255.255.255.224',
            broadcast => '46.4.71.255',
            gateway   => '46.4.71.225',
            subnet    => '46.4.71.224/27';
    }
}
*/

/*\  API
\*/
node /stable.api/ inherits nodenode {
    File <| tag == 'api_restart' |>
    class { 'managed':
        intent => 'data-api',
        rank   => 'stable',
        url    => 'git@github.com:dicole/data-api-node.git'
    }
}
node /live.api/ inherits nodenode {
    File <| tag == 'api_restart' |>
    class { 'managed':
        intent => 'data-api',
        rank   => 'live',
        url    => 'git@github.com:dicole/data-api-node.git'
    }
}
node /beta.api/ inherits nodenode {
    File <| tag == 'api_restart' |>
    class { 'managed':
        intent => 'data-api',
        rank   => 'beta',
        url    => 'git@github.com:dicole/data-api-node.git'
    }
}
node /alpha.api/ inherits nodenode {
    File <| tag == 'api_restart' |>
    class { 'managed':
        intent => 'data-api',
        rank   => 'alpha',
        url    => 'git@github.com:dicole/data-api-node.git'
    }
}
node /test.api/ inherits testnode {
    File <| tag == 'api_restart' |>
    class { 'managed':
        intent => 'data-api',
        rank   => 'test',
        url    => 'git@github.com:dicole/data-api-node.git'
    }
}
node dev-api inherits nodenode {
    File <| tag == 'api_restart' |>
    class { 'managed':
        intent => 'data-api',
        rank   => 'dev',
        url    => 'git@github.com:dicole/data-api-node.git'
    }
}

/*\  BACKUP
 *
 *  Do backups of several databases, Mogilefs files and some other stuff.
 *
 *  All *_cron parameters are cron(8) time and date field strings, except
 *  with backup::rsync where they are only the time portion of the string.
\*/
node backup-1 inherits domU {
    class {
        'backup':;
        'backup::stat':;

        'backup::mogile': dev1_cron   => "10 8  * * 6",
                          dev2_cron   => "15 8  * * 6",
                          live1_cron  => "20 8  * * *",
                          live2_cron  => "25 8  * * *";

        'backup::mysql':  dev_cron    => "10 9  * * 3",
                          blog_cron   => "20 9  * * *",
                          main_cron   => "30 9  * * *";

        'backup::rsync':  blog1_cron  => "10 6",
                          blog2_cron  => "20 6",
                          media1_cron => "30 6",
                          media2_cron => "40 6",
                          devdcp_cron => "50 3";
    }
}
node backup-2 inherits domU {
    class {
        'backup':;

        'backup::mogile': dev1_cron   => "30 8  * * 3",
                          dev2_cron   => "35 8  * * 3",
                          live1_cron  => "40 8  * * *",
                          live2_cron  => "45 8  * * *";

        'backup::mysql':  dev_cron    => "10 0  * * 6",
                          blog_cron   => "20 0  * * *",
                          main_cron   => "30 0  * * *";

        'backup::rsync':  blog1_cron  => "10 7",
                          blog2_cron  => "20 7",
                          media1_cron => "30 7",
                          media2_cron => "40 7",
                          devdcp_cron => "50 4";
    }
}

/*\  BLOG
\*/
node /live.blog/ inherits domU {
    File <| tag == 'log_apache' |>

    class {
        'backup::access':;
        'sites::blog':;
        'varnish': flavor => 'blog';
    }
}

/*\  CORE
\*/
node /live.http.core/ inherits domU {
    File <| tag == 'restart_services' |>
    class {
        'dcp':
            flavor => 'live';
        'dcp::lighty':
            flavor => 'live';
        'managed':
            auto   => false,
            intent => 'dcp',
            role   => 'http',
            rank   => 'live',
            url    => 'git@github.com:dicole/dcp.git';
    }
}
node /live.worker.core/ inherits domU {
    File <| tag == 'restart_workers' |>
    class {
        'dcp':
            flavor => 'live';
        'managed':
            auto   => false,
            intent => 'dcp',
            role   => 'worker',
            rank   => 'live',
            url    => 'git@github.com:dicole/dcp.git';
    }
}
node /beta.http.core/ inherits domU {
    File <| tag == 'restart_services' |>
    class {
        'dcp':
            flavor => 'beta';
        'dcp::lighty':
            flavor => 'beta';
        'managed':
            intent => 'dcp',
            role   => 'http',
            rank   => 'beta',
            url    => 'git@github.com:dicole/dcp.git';
    }
}
node /beta.worker.core/ inherits domU {
    File <| tag == 'restart_workers' |>
    class {
    'dcp':
        flavor => 'beta';
    'managed':
        intent => 'dcp',
        role   => 'worker',
        rank   => 'beta',
        url    => 'git@github.com:dicole/dcp.git';
    }
}
node test-cron-core-1 inherits testU {
    class {
        'dcp':
            flavor => 'test';
        'managed':
            intent => 'dcp',
            role   => 'cron',
            rank   => 'test',
            url    => 'git@github.com:dicole/dcp.git';
    }
}
node /test.http.core/ inherits testU {
    class {
        'dcp':
            flavor => 'test';
        'dcp::lighty':
            flavor => 'test';
        'managed':
            intent => 'dcp',
            role   => 'http',
            rank   => 'test',
            url    => 'git@github.com:dicole/dcp.git';
    }
}
node /test.worker.core/ inherits testU {
    File <| tag == 'restart_workers' |>
    class {
        'dcp':
            flavor => 'test';
        'managed':
            intent => 'dcp',
            role   => 'worker',
            rank   => 'test',
            url    => 'git@github.com:dicole/dcp.git';
    }
}
node /dev.core/ inherits domU {
    class {
        'dcp':
            flavor => 'dev';
        'dcp::lighty':
            flavor => 'dev';
        'managed':
            intent => 'dcp',
            rank   => 'beta',
            url    => 'git@github.com:dicole/dcp.git';
    }
}

/*\  CUTIES
\*/
node /live.cuty/ inherits nodenode {
    class { 'cuty::capt': }
    class { 'managed':
        intent => 'cuty-rpc',
        rank   => 'live',
        url    => 'git@github.com:dicole/cuty-rpc.git'
    }
}
node test-cuty-1 inherits testnode {
    class { 'cuty::capt': }
    class { 'managed':
        intent => 'cuty-rpc',
        rank   => 'test',
        url    => 'git@github.com:dicole/cuty-rpc.git'
    }
}

/*\  EVENTS
\*/
node /live.events/ inherits domU {
    class { 'events': peer_url => 'http://localhost:9000' }
}
node dev-events inherits domU {
    class { 'events': }
}

/*\  FRONT
 *
 *  A production ready front has three services:
 *
 *   nginx   - ssl termination
 *   perlbal - reverse proxy
 *   varnish - http cache
 *
 *  Also, they have specialized network configuration
 *  and may have autodeployable service.
\*/
node /live.front/ inherits default {
    File <| tag == 'log_nginx' |>
    File <| tag == 'log_slave' |>

    class {
        'nginx::front':;

        'perlbal':
            flavor => 'live';
        'varnish':
            flavor => 'live';
    }
}
node /test.front/ inherits default {
    File <| tag == 'log_slave' |>

    class {
        'nodejs':;

        'perlbal':
            flavor => 'test';
        'managed':
            intent => 'pollbal',
            rank   => 'test',
            url    => 'git@github.com:dicole/pollbal.git';
    }
}

/*\  GEARMEN
\*/
node /live.gearman/ inherits domU {
    class { 'gearman':; }
}
node /beta.gearman/ inherits domU {
    class { 'gearman':; }
}
node /test.gearman/ inherits testU {
    class { 'gearman':; }
}
node /dev.gearman/ inherits domU {
    class { 'gearman':; }
}

/*\  GEARSLOTH
\*/
node /live.sloth/ inherits nodenode {
    class {
        'sloth': config => 'live';
    }
}
node /beta.sloth/ inherits nodenode {
    class {
        'sloth': config => 'beta';
    }
}
node /dev.sloth/ inherits nodenode {
    class {
        'sloth': config => 'dev';
    }
}

/*\  MEDIA
\*/
node /legacy.media/ inherits domU {
    File <| tag == 'log_apache' |>

    class {
        'backup::access':;
        'sites::media':;
    }
}

/*\  MEMCACHED
\*/
node /live.memcached/ inherits domU {
    class { 'memcached':; }
}
node /beta.memcached/ inherits domU {
    class { 'memcached':; }
}
node /test.memcached/ inherits testU {
    class { 'memcached':; }
}
node /dev.memcached/ inherits domU {
    class { 'memcached':; }
}

/*\  MINER
\*/
node miner inherits domU {
    class {
        'miner':;
        'mysql':;

        'dcp':
            flavor => 'miner';
        'managed':
            intent => 'dcp',
            rank   => 'master',
            url    => 'git@github.com:dicole/dcp.git';
    }
}

/*\  MOGILE
\*/
node /live.mogile/ inherits domU {
    class {
        'backup::access':;
        'mogile': trackers => '127.0.0.2:7001,127.0.0.3:7001';
    }
}
node /test.mogile/ inherits testU {
    class {
        'mogile': trackers => '127.0.0.4:7001,127.0.0.5:7001'
    }
}
node /dev.mogile/ inherits domU {
    class {
        'backup::access':;
        'mogile': trackers => '127.0.0.6:7001,127.0.0.7:7001';
    }
}

node mm-mysql-5 inherits domU {
    class { 'mysql::multimaster':
        server_id       => '5',
        auto_increment  => '2',
        inc_offset      => '1',
        binlog_expire   => '31',
        slave_check_min => '*/2';
    }
}
node mm-mysql-6 inherits domU {
    class { 'mysql::multimaster':
        server_id       => '6',
        auto_increment  => '2',
        inc_offset      => '2',
        binlog_expire   => '31',
        slave_check_min => '*/2';
    }
}
node blog-mysql-1 inherits domU {
    class { 'mysql::multimaster':
        server_id       => '1',
        auto_increment  => '3',
        inc_offset      => '1',
        binlog_expire   => '7',
        slave_check_min => '*/5';
    }
}
node blog-mysql-2 inherits domU {
    class { 'mysql::multimaster':
        server_id       => '2',
        auto_increment  => '3',
        inc_offset      => '2',
        binlog_expire   => '7',
        slave_check_min => '*/5';
    }
}
node blog-mysql-3 inherits domU {
    class { 'mysql::multimaster':
        server_id       => '3',
        auto_increment  => '3',
        inc_offset      => '3',
        binlog_expire   => '7',
        slave_check_min => '*/5';
    }
}
node test-mysql-1 inherits testU {
    class { 'mysql::multimaster':
        server_id       => '1',
        auto_increment  => '2',
        inc_offset      => '1',
        binlog_expire   => '14';
    }
}
node test-mysql-2 inherits testU {
    class { 'mysql::multimaster':
        server_id       => '2',
        auto_increment  => '2',
        inc_offset      => '2',
        binlog_expire   => '14';
    }
}
node dev-mysql inherits domU {
    class { 'mysql': }
}

/*\  NAG
\*/
node /^nag/ inherits nodenode {
    class { 'nag': }
    class { 'managed':
        intent => 'nag',
        rank   => 'master',
        url    => 'git@github.com:dicole/nag.git'
    }
}

/*\  STATS
\*/
node live-stats-1 inherits nodenode {
    class { 'managed':
        intent => 'stats',
        rank   => 'live',
        url    => 'git@github.com:dicole/stats.git'
    }
}
node test-stats-1 inherits testnode {
    common::adduser {
        'jarno': comment => 'Jarno M';
    }

    class { 'managed':
        intent => 'stats',
        rank   => 'test',
        url    => 'git@github.com:dicole/stats.git'
    }
}

/*\  URL CACHE
\*/
node /live-urlcache/ inherits nodenode {
    class { 'managed':
        intent => 'paint',
        rank   => 'live',
        url    => 'git@github.com:dicole/paint.git'
    }
}
node /test-urlcache/ inherits testnode {
    class { 'managed':
        intent => 'paint',
        rank   => 'test',
        url    => 'git@github.com:dicole/paint.git'
    }
}

/*\  WEBSITES
\*/
node live-web-1 inherits domU {
    class { 'sites::web': }
    class { 'managed':
        intent => 'web',
        rank   => 'live',
        url    => 'git@github.com:dicole/websites.git'
    }
}
node live-web-2 inherits domU {
    class { 'sites::web': }
    class { 'managed':
        intent => 'web',
        rank   => 'live',
        url    => 'git@github.com:dicole/websites.git'
    }
}

/*\  NODEJS WORKERS
\*/
node /dev.worker.js/ inherits nodenode {
    class { 'managed':
        intent => 'worker-js',
        rank   => 'dev',
        url    => 'git@github.com:dicole/worker-js.git'
    }
}
node /beta.worker.js/ inherits nodenode {
    class { 'managed':
        intent => 'worker-js',
        rank   => 'beta',
        url    => 'git@github.com:dicole/worker-js.git'
    }
}
node /live.worker.js/ inherits nodenode {
    class { 'managed':
        intent => 'worker-js',
        rank   => 'live',
        url    => 'git@github.com:dicole/worker-js.git'
    }
}
