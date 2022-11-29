#!/usr/bin/perl

my @confs = ();
my $tmpl = `cat /etc/lighttpd/dcp-fcgi.tmpl`;

for my $n (1..8) {
    my $conf = $tmpl;
    $conf =~ s/\<\<NUM\>\>/$n/g;
    push @confs, $conf;
}

print "fastcgi.server = (\"/\" => (\n" . join(",\n", @confs) . "))\n";
