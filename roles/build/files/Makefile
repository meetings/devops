# Makefile version 2017-01-02-xenial
# vim: set sw=4 ts=4 sts=4 nolist :

FPM = fpm
PARAMS = -s cpan -t deb --verbose --no-auto-depends --maintainer "tuomas@meetin.gs"

.PHONY: help
help:
	@echo ''
	@echo 'Build targets:'
	@echo '  <package-name>  - Build specific package and its dependencies'
	@echo '  for-dcp         - Build all DCP dependencies'
	@echo ''
	@echo 'For details, see the Makefile'
	@echo ''

.PHONY: clean
clean:
	@rm -rf *.deb ~/.cpanm

.PHONY: all
all: for-dcp libperlbal-plugin-extredirector-perl

.PHONY: for-dcp
for-dcp: libbusiness-paypal-nvp-perl libclass-fields-perl libclass-observable-perl libconvert-scalar-perl libdata-leaf-walker-perl libdate-ical-perl libdatetime-format-cldr-perl libhtml-scrubber-stripscripts-perl libhtml-summary-perl liblist-util-perl liblog-log4perl-appender-raven-perl libmogilefs-client-perl libnet-oauth-simple-perl librdf-simple-perl libsentry-raven-perl libtext-diff3-perl libwww-mailchimp-perl libwww-pusher-perl libxml-atom-syndication-perl libxml-liberal-perl

.PHONY: libperlbal-plugin-extredirector-perl
libperlbal-plugin-extredirector-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-v 0.0.4 -d perlbal \
	--description "Use Squid rules in Perlbal" Perlbal::Plugin::Extredirector

.PHONY: libbusiness-paypal-nvp-perl
libbusiness-paypal-nvp-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	--description "PayPal's name-value pair API" Business::PayPal::NVP

.PHONY: libclass-fields-perl
libclass-fields-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libcarp-assert-perl \
	--description "Inspect the fields of a class" Class::Fields

.PHONY: libclass-observable-perl
libclass-observable-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libclass-isa-perl \
	--description "Allow other classes and objects to respond to events in yours" Class::Observable

.PHONY: libconvert-scalar-perl
libconvert-scalar-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	--description "Convert between different representations of scalars" Convert::Scalar

.PHONY: libdata-leaf-walker-perl
libdata-leaf-walker-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	--description "Walk the leaves of arbitrarily deep nested data structures" Data::Leaf::Walker

.PHONY: libdate-ical-perl
libdate-ical-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libdate-leapyear-perl \
	--description "Perl extension for ICalendar date objects" Date::ICal

.PHONY: libdatetime-format-cldr-perl
libdatetime-format-cldr-perl: libdatetime-incomplete-perl
	test -f $@* || $(FPM) $(PARAMS) -n $@ --no-cpan-test \
	-d libdatetime-perl \
	-d libdatetime-incomplete-perl \
	-d libdatetime-locale-perl \
	-d libdatetime-timezone-perl \
	-d libparams-validate-perl \
	--description "Parse and format CLDR time patterns" DateTime::Format::CLDR

.PHONY: libdatetime-incomplete-perl
libdatetime-incomplete-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libdatetime-event-recurrence-perl \
	-d libdatetime-set-perl \
	--description "Parse incomplete datetimes" DateTime::Incomplete

.PHONY: libhtml-scrubber-stripscripts-perl
libhtml-scrubber-stripscripts-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libhtml-scrubber-perl \
	--description "Strip scripts from HTML" HTML::Scrubber::StripScripts
	# git@github.com:dicole/HTML-Scrubber-StripScripts.git

.PHONY: libhtml-summary-perl
libhtml-summary-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libhtml-tree-perl \
	-d libjcode-perl \
	--description "Generate a summary from a web page" HTML::Summary

.PHONY: liblist-util-perl
liblist-util-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	--description "A selection of general-utility list subroutines" List::Util

.PHONY: liblog-log4perl-appender-raven-perl
liblog-log4perl-appender-raven-perl: libsentry-raven-perl
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libdevel-stacktrace-perl \
	-d liblog-log4perl-perl \
	-d libmoose-perl \
	-d libsentry-raven-perl \
	--description "Append log events to your Sentry account" Log::Log4perl::Appender::Raven

.PHONY: libmogilefs-client-perl
libmogilefs-client-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libio-stringy-perl \
	-d libwww-perl \
	--description "Client library for the MogileFS" MogileFS::Client

.PHONY: libnet-oauth-simple-perl
libnet-oauth-simple-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libnet-oauth-perl \
	-d libcrypt-ssleay-perl \
	-d liburi-perl \
	-d libwww-perl \
	--description "Simple wrapper round the OAuth protocol" Net::OAuth::Simple

.PHONY: librdf-simple-perl
librdf-simple-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libclass-makemethods-perl \
	-d libfile-slurp-perl \
	-d libregexp-common-perl \
	-d liburi-perl \
	-d libxml-sax-perl \
	--description "Read and write RDF without complication" RDF::Simple

.PHONY: libsentry-raven-perl
libsentry-raven-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libdatetime-perl \
	-d libdevel-stacktrace-perl \
	-d libhttp-message-perl \
	-d libjson-xs-perl \
	-d liblwp-protocol-https-perl \
	-d libmoo-perl \
	-d libmoox-types-mooselike-perl \
	-d liburi-perl \
	-d libuuid-tiny-perl \
	-d libwww-perl \
	--description "A Perl sentry client" Sentry::Raven

.PHONY: libtext-diff3-perl
libtext-diff3-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libtest-base-perl \
	--description "Three way text comparison and merging" Text::Diff3

.PHONY: libwww-mailchimp-perl
libwww-mailchimp-perl: libphp-httpbuildquery-perl
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libjson-perl \
	-d libmoo-perl \
	-d libmoox-types-mooselike-perl \
	-d libphp-httpbuildquery-perl \
	-d libsub-name-perl \
	-d liburi-perl \
	-d libwww-perl \
	--description "Simple wrapper around the Mailchimp API" WWW::Mailchimp

.PHONY: libphp-httpbuildquery-perl
libphp-httpbuildquery-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d liburi-perl \
	--description "Data structures to form-encoded query strings" PHP::HTTPBuildQuery

.PHONY: libwww-pusher-perl
libwww-pusher-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libtest-deep-perl \
	-d libjson-perl \
	-d liburi-perl \
	-d libwww-perl \
	--description "Interface to the Pusher WebSockets API" WWW::Pusher

.PHONY: libxml-atom-syndication-perl
libxml-atom-syndication-perl: libxml-elemental-perl
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libclass-errorhandler-perl \
	-d libxml-elemental-perl \
	-d libxml-writer-perl \
	--description "Portable client for consuming RFC 4287 feeds" XML::Atom::Syndication

.PHONY: libxml-elemental-perl
libxml-elemental-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libtask-weaken-perl \
	-d libxml-sax-perl \
	--description "Simplistic and perlish handling of XML data" XML::Elemental

.PHONY: libxml-liberal-perl
libxml-liberal-perl:
	test -f $@* || $(FPM) $(PARAMS) -n $@ \
	-d libmodule-pluggable-fast-perl \
	-d libhtml-parser-perl \
	-d libhtml-tagset-perl \
	-d libuniversal-require-perl \
	-d libxml-libxml-perl \
	--description "Super liberal XML parser that parses broken XML" XML::Liberal
