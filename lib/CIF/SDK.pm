package CIF::SDK;

use 5.011;
use strict;
use warnings FATAL => 'all';

use CIF::SDK::Logger;

use YAML::Tiny;

=head1 NAME

CIF::SDK - The CIF Software Development Kit

=cut

our $VERSION        = '0.00_23';
our $API_VERSION    = 2;

=head1 VERSION

Version $VERSION

=cut

=head1 SYNOPSIS

the SDK is a thin development kit for developing CIF applications

    use 5.011;
    use CIF::SDK::Client;
    use feature 'say';

    my $cli = CIF::SDK::Client->new({
        token       => '1234',
        remote      => 'https://localhost/v2',
        timeout     => 10,
        verify_ssl  => 0,
    });
    
    my ($err,$ret) = $cli->ping();
    say 'roundtrip: '.$ret.' ms';
    
    ($err,$ret) = $cli->search({
        query       => $query,
        confidence  => $confidence,
        limit       => $limit,
    });
    
    my $formatter = CIF::SDK::FormatFactory->new_plugin({ format => 'json' });
    my $text = $formatter->process($ret);
    say $text;
    

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

init_logging $Logger

=cut

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
    init_logging observable_type parse_config
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

use vars qw(
    $Logger
);

our @EXPORT = qw(
    $Logger 
);

sub init_logging {
    my $args        = shift;
	
    $args = { level => $args } unless(ref($args) && ref($args) eq 'HASH');
	unless($args->{'category'}){
		my ($funct,$bin,$line) = caller();
		$args->{'category'} = $bin;
	}

    $Logger = CIF::SDK::Logger->new($args);
   
    if($args->{'filename'}){
        my $appender = Log::Log4perl::Appender->new(
            'Log::Log4perl::Appender::File', 
            mode                => 'append',
            %$args
        );
        $appender->layout(
            Log::Log4perl::Layout::PatternLayout->new(
                $Logger->get_layout()
            )
        );
        $Logger->get_logger()->add_appender($appender);
    }
    $Logger = $Logger->get_logger();
}

# push these out to make this code simpler to read
# we still export the symbols though
use CIF::SDK::Plugin::Address qw(:all);
use CIF::SDK::Plugin::Hash qw(:all);
#use CIF::SDK::Plugin::Binary qw(:all);
#use CIF::SDK::Plugin::DateTime qw(:all);

sub observable_type {
    my $arg = shift || return;
    
    return 'url'    if(is_url($arg));
    return 'ipv4'   if(is_ipv4($arg));
    return 'ipv6'   if(is_ipv6($arg));
    return 'fqdn'   if(is_fqdn($arg));
    return 'email'  if(is_email($arg));
    return 'hash'   if(is_hash($arg));
    return 'binary' if(is_binary($arg));
    return 0;
}

sub parse_config {
	my $config = shift;
	
	return unless(-e $config);
    $config = YAML::Tiny->read($config)->[0];
    return $config;
}

=head1 BUGS AND SUPPORT

Please report any bugs at L<http://github.com/csirtgadgets/cif-sdk-perl/issues>.

=head1 AUTHOR

    Wes Young <wes@barely3am.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 the CSIRT Gadgets Foundation

This program is free software; you can redistribute it and/or modify it
under the terms of the the LGPL (v3). 

=cut

1; # End of CIF::SDK
