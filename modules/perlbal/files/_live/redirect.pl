#!/usr/bin/perl -p

BEGIN {
    $| = 1;
    $last_modification_time = 0;
    $last_update_time = 0;
    $file = '/etc/perlbal/redirect.rules';
    $file_working = '/etc/perlbal/redirect.rules.working';

    sub prepare_rules_sub {
        my $code = '$rules_sub = sub { $_ = shift @_; for my $i (1) { '.$rules.' }; return $_ };';
        eval $code;
    }

    sub reload_rules {
        if ( system( perl => -c => $file ) == 0 ) {
            $rules = `cat $file`;
            prepare_rules_sub();
            system( cp => $file => $file_working );
        }
        else {
            $rules = `cat $file_working`;
            prepare_rules_sub();
        }
    }
}

$now = time();

if ( $now - 1 > $last_update_time ) {
    $now_mod_time = (stat $file)[9];
    if ( $now_mod_time > $last_modification_time ) {
        reload_rules();
        $last_modification_time = $now_mod_time;
    }
    $last_update_time = $now;
}

$_ = $rules_sub->( $_ );
