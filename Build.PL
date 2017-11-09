#!/usr/bin/env perl
use 5.016;
use strict;
use warnings;

use Module::Build;

my @scripts = glob 'bin/*';

my $build = Module::Build->new(
    module_name  => 'API::YouTube',
    script_files => \@scripts,
    requires => {
        'HTTP::Tiny'      => '0.055',
        'IO::Socket::SSL' => 0,
        'JSON'            => 0,
        'Text::CSV'       => 0,
        'Try::Tiny'       => 0,
        'URI::Find'       => 0,
        'perl'            => '5.016',
    },
    test_requires => {
        'Test::More'             => 0,
        'Test::RequiresInternet' => 0,
    },
);

$build->create_build_script;
