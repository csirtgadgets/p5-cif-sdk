use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'CIF::SDK',
    AUTHOR           => q{Wesley Young <wes@csirtgadgets.com>},
    VERSION_FROM     => 'lib/CIF/SDK.pm',
    ABSTRACT_FROM    => 'lib/CIF/SDK.pm',
    VERSION_FROM    => 'lib/CIF/SDK.pm',
    LICENSE          => 'LGPL_3',
    EXE_FILES       => ['bin/cif'],
    MIN_PERL_VERSION => 5.014,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
        'DateTime'              => 0,
        'Net::DNS::Match'       => '0.05',
        'Net::Patricia'         => '1.22',
        'Mouse'                 => '2.00300',
        'JSON::XS'              => 0,
        'Text::Table'           => 0,
        'Snort::Rule'           => '1.07',
        'Regexp::Common'        => 0,
        'Regexp::Common::net'   => 0,
        'Regexp::Common::net::CIDR' => 0,
        'Regexp::IPv6'          => 0,
        'Parse::Range'          => 0,
        'Log::Log4perl'         => '1.44',
        'Time::HiRes'           => 0,
        'Module::PluginFinder'  => '0.04',
        'Net::SSLeay'           => '1.49',
        'Mail::RFC822::Address' => 0,
        'YAML::Tiny'            => '1.63',
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'test-*' },
);
