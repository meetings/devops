/* Module: dcp
 *
 * 2015-04-28 / Meetin.gs
 */
class dcp($flavor) {
    realize Package['mysql-client']

    class {
        'dcp::files': flavor => $flavor
    }

    $packages = [
        /* Fresh from Meetin.gs repository!
         */
        'libbusiness-paypal-nvp-perl',
        'libcache-memcached-getparserxs-perl',
        'libclass-fields-perl',
        'libclass-observable-perl',
        'libconvert-scalar-perl',
        'libdata-leaf-walker-perl',
        'libdate-ical-perl',
        'libdatetime-format-cldr-perl', /* dep: libdatetime-incomplete-perl */
        'libhtml-scrubber-stripscripts-perl',
        'libhtml-summary-perl',
        'liblog-log4perl-appender-raven-perl', /* dep: libsentry-raven-perl */
        'libmogilefs-client-perl',
        'libnet-oauth-simple-perl',
        'libnumber-phone-perl',
        'librdf-simple-perl',
        'libtext-diff3-perl',
        'libwww-mailchimp-perl', /* dep: libphp-httpbuildquery-perl */
        'libwww-pusher-perl',
        'libxml-atom-syndication-perl', /* dep: libxml-elemental-perl */
        'libxml-liberal-perl',

        /* SPOPS will be satisfied with these.
         */
        'libcarp-assert-perl',
        'libclass-accessor-perl',
        'libclass-date-perl',
        'libclass-factory-perl',
        'liblog-dispatch-perl',
        'liblog-log4perl-perl',

        /* OpenInteract is clearly more demanding,
         * but the following should do it.
         */
        'libalgorithm-dependency-perl',
        'libapache-session-perl',
        'libarchive-zip-perl',
        'libcache-cache-perl',
        'libcgi-fast-perl',
        'libclass-singleton-perl',
        'libdatetime-format-strptime-perl',
        'libdatetime-perl',
        'libdbd-sqlite3-perl',
        'libdbi-perl',
        'libdevel-stacktrace-perl',
        'libemail-valid-perl',
        'libexception-class-perl',
        'libfile-mmagic-perl',
        'libhtml-tagcloud-perl',
        'liblingua-stem-perl',
        'libmail-rfc822-address-perl',
        'libmail-sendmail-perl',
        'libmime-lite-perl',
        'libnet-oauth-perl',
        'libpod-pom-perl',
        'libtemplate-perl',
        'libtest-mockobject-perl',
        'liburi-encode-perl',
        'liburi-perl',
        'libwww-perl',

        /* And finally, here's Community Platforms
         * dependencies.
         */
        'geoip-database',
        'libalgorithm-diff-perl',
        'libcache-memcached-perl',
        'libchi-perl',
        'libclone-perl',
        'libcrypt-cbc-perl',
        'libcrypt-rijndael-perl',
        'libdata-dump-perl',
        'libdata-ical-perl',
        'libdata-structure-util-perl',
        'libdatetime-format-ical-perl',
        'libdatetime-format-iso8601-perl',
        'libdatetime-format-mail-perl',
        'libdbd-mysql-perl',
        'libdigest-sha-perl',
        'libemail-address-perl',
        'libfeed-find-perl',
        'libfile-mimeinfo-perl',
        'libfile-ncopy-perl',
        'libfile-sharedir-install-perl',
        'libfile-slurp-perl',
        'libgearman-client-perl',
        'libgeography-countries-perl',
        'libgeo-ip-perl',
        'libhtml-scrubber-perl',
        'libhtml-stripscripts-parser-perl',
        'libintl-perl',
        'libio-all-perl',
        'libjson-perl',
        'liblocale-maketext-lexicon-perl',
        'liblocale-po-perl',
        'libmime-tools-perl',
        'libmoose-perl',
        'libmoosex-has-sugar-perl',
        'libmp3-info-perl',
        'libnet-ldap-perl',
        'libnet-openid-consumer-perl',
        'libnet-subnets-perl',
        'librpc-xml-perl',
        'libspreadsheet-parseexcel-perl',
        'libspreadsheet-writeexcel-perl',
        'libsys-sigaction-perl',
        'libtext-csv-perl',
        'libtext-csv-xs-perl',
        'libtext-markdown-perl',
        'libtext-unidecode-perl',
        'libtext-wikiformat-perl',
        'libunicode-maputf8-perl',
        'liburi-find-perl',
        'libxml-feed-perl',
        'libxml-feedpp-perl',
        'libxml-libxml-perl',
        'libxml-opml-perl',
        'libxml-parser-perl',
        'libxml-rss-libxml-perl',
        'libxml-rss-perl',
        'libxml-simple-perl',
        'libxml-writer-perl',
        'libyaml-syck-perl',
        'perlmagick',
        'make'
    ]

    package {
        $packages: ensure => installed
    }
}
