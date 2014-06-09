use inc::Module::Install;

name            'CIF-SDK';
perl_version    5.011;
all_from        'lib/CIF/SDK.pm';
license         'LGPL_3_0';
install_script  'bin/cif';

requires 'Mouse'                => '2.1.0';
requires 'JSON::XS'             => 0;
requires 'Text::Table'          => 0;
requires 'Snort::Rule'          => 1.07;
requires 'Regexp::Common'       => 0;
requires 'Parse::Range'         => 0;
requires 'Log::Log4perl'        => 0;
requires 'Time::HiRes'          => 0;
requires 'Config::Simple'       => 4.58;
requires 'Module::PluginFinder' => 0.04;
requires 'Net::SSLeay'          => '1.49';

WriteAll;
