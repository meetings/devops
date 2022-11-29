
## Sites

### Blog site

1. Create [a domU](creating-domU.md) with a good amount of memory and
   lots of cores. See *puppet*(8) class *sites::blog* for details.

2. Enable **rewrite** module.

        # a2enmod rewrite

   Also, default site configuration should allow *FileInfo* and
   *Options* to be overriden in **/var/www**. This should have been
   taken care by *puppet*.

3. To get the **/var/www** synchronization working, enable *ssh*(1)
   to connect to the other blog host.

   *For example:*

        Host live-blog-1
          Port 20000
          HostName gateway.dicole.com

   Also, remember to add public keys to *authorized_keys*.

4. Add the following to system *crontab*(5):

        # Following line MAY be uncommented on PASSIVE hosts ONLY!
        #*/10 *  * * *   root    /usr/local/sbin/meetings_sync_var_www.sh live-blog-n
        #
        # Following line MUST be uncommented on ACTIVE host ONLY!
        #*    *  * * *   root    /usr/local/mbin/portforward/ensure_my_connections.pl --hostname live-blog-a
        #
        # Following line MUST be present on active host, but does no harm anywhere else.
        #*    *  * * *  nobody   /usr/bin/curl -so /dev/null -X REFRESH -H "Host: www.meetin.gs" http://127.0.0.1:8000

   Change *live-blog-n* to a real remote host name and uncomment one
   line per instructions.


### Websites

1. Create [a domU](creating-domU.md). See *puppet*(8) class *sites::web*
   for details.

2. Enable PHP and FastCGI modules.

        # lighty-enable-mod cgi
        # lighty-enable-mod fastcgi
        # lighty-enable-mod fastcgi-php


### Legacy media

1. Create [a domU](creating-domU.md). See *puppet*(8) class *sites::media*
   for details.

2. To get the **/var/www** synchronization working, you need to
   configure *ssh*(1) for the target host.

   This is an example:

        Host legacy-media-1
          Port 20013
          HostName gateway.dicole.com

3. Claim active role on one of the servers. Use the following:

        # Following line MAY be uncommented on PASSIVE hosts ONLY!
        #*/10 *  * * *   root    /usr/local/sbin/meetings_sync_var_www.sh legacy-media-n
        #
        # Following line MUST be uncommented on ACTIVE host ONLY!
        #*    *  * * *   root    /usr/local/mbin/portforward/ensure_my_connections.pl --hostname legacy-media-a
