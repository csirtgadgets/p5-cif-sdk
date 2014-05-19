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
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'CIF-SDK-*' },
);
