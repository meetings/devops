#!/usr/bin/perl

use strict;
use CGI::Fast;
use File::Spec::Functions     qw(catfile);
use Log::Log4perl             qw(get_logger);
use OpenInteract2::Auth;
use OpenInteract2::Controller;
use OpenInteract2::Context;
use OpenInteract2::Constants  qw(:log);
use OpenInteract2::Request;
use OpenInteract2::Response;

{
    my $website_dir = '/usr/local/dcp';
    Log::Log4perl::init( File::Spec->catfile( $website_dir, 'conf', 'log4perl.conf' ) );

    my $ctx = OpenInteract2::Context->create({ website_dir => $website_dir });
    $ctx->assign_request_type( 'cgi' );
    $ctx->assign_response_type( 'cgi' );

    while ( my $fcgi_request = CGI::Fast->new ) {
        my $response = OpenInteract2::Response->new({ cgi => $fcgi_request });
        $response->initialize_trace;

        my $request  = OpenInteract2::Request->new({ cgi => $fcgi_request });

        OpenInteract2::Auth->new()->login();

        my $controller = eval {
            OpenInteract2::Controller->new( $request, $response )
        };
        if ( $@ ) {
            get_logger(LOG_APP)->error("Controller returned error: $@");
            $response->content( $@ );
        }
        else {
            $controller->execute;
        }

        $response->send;

        $ctx->cleanup_request;
    }
}
