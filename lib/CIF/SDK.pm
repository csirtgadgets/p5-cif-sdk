package CIF::SDK;

use 5.011;
use strict;
use warnings FATAL => 'all';

use CIF::SDK::Logger;

=head1 NAME

CIF::SDK - The CIF Software Development Kit

=cut

our $VERSION = '0.00_01';

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
        remote      => 'https://localhost/api',
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
    init_logging
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
