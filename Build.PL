use 5.011;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'CIF::SDK',
    license             => 'LGPL_3_0',
    dist_author         => q{Wes Young <wes@barely3am.com>},
    dist_version_from   => 'lib/CIF/SDK.pm',
    script_files        => ['bin/cif','bin/cif-feed'],
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More'    => 0,
    },
    requires => {
        'Net::DNS::Match'       => '0.05',
        'Net::Patricia'         => '1.22',
        'Mouse'                 => '2.00300',
        'JSON::XS'              => 0,
        'Text::Table'           => 0,
        'Snort::Rule'           => '1.07',
        'Regexp::Common'        => 0,
        'Regexp::Common::net'   => 0,
        'Regexp::IPv6'          => 0,
        'Parse::Range'          => 0,
        'Log::Log4perl'         => '== 1.44',
        'Time::HiRes'           => 0,
        'Module::PluginFinder'  => '0.04',
        'Net::SSLeay'           => '1.49',
        'Mail::RFC822::Address' => 0,
        'YAML::Tiny'            => '1.63',
    },
    add_to_cleanup     => [ 'CIF-SDK-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
