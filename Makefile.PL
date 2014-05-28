use 5.011;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;
use ExtUtils::MakeMaker::CPANfile;

WriteMakefile(
    NAME             => 'CIF::SDK',
    AUTHOR           => q{"Wes Young" <"wes@barely3am.com">},
    VERSION_FROM     => 'lib/CIF/SDK.pm',
    ABSTRACT_FROM    => 'lib/CIF/SDK.pm',
    LICENSE          => 'Artistic_2_0',
    EXE_FILES       => ['bin/cif'],
    MIN_PERL_VERSION => 5.011,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Mouse'             => 2.2,
        'JSON::XS'          => 0,
        'Text::Table'       => 0,
        'Snort::Rule'       => 0,
        'Regexp::Common'    => 0,
        'Parse::Range'      => 0,
        'Log::Log4perl'     => 0,
        
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'CIF-SDK-*' },
);
