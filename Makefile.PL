use inc::Module::Install;

name            'CIF-SDK';
perl_version    5.011;
all_from        'lib/CIF/SDK.pm';
license         'LGPL_3_0';
install_script  'bin/cif';

requires 'Net::DNS::Match'          => '0.05';
requires 'Net::Patricia'            => '1.22';
requires 'Mouse'                    => '2.3.0';
requires 'JSON::XS'                 => 0;
requires 'Text::Table'              => 0;
requires 'Snort::Rule'              => 1.07;
requires 'Regexp::Common'           => 0;
requires 'Regexp::Common::net';
requires 'Regexp::IPv6';
requires 'Parse::Range'             => 0;
requires 'Log::Log4perl'            => 0;
requires 'Time::HiRes'              => 0;
requires 'Module::PluginFinder'     => 0.04;
requires 'Net::SSLeay'              => '1.49';
requires 'Mail::RFC822::Address'    => 0;
requires 'YAML::Tiny'               => '1.63';

WriteAll;
