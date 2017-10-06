#!/usr/bin/env perl
use 5.016;
use strict;
use warnings;

use ExtUtils::MakeMaker;

my @scripts = glob 'bin/*';

WriteMakefile(
    AUTHOR             => ['Aaron L. Zeng <me@bcc32.com>'],
    NAME               => 'API::YouTube',
    ABSTRACT_FROM      => 'lib/API/YouTube.pm',
    VERSION_FROM       => 'lib/API/YouTube.pm',
    EXE_FILES          => \@scripts,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    PREREQ_PM => {
        'HTTP::Tiny'      => 0,
        'IO::Socket::SSL' => 0,
        'JSON'            => 0,
        'Text::CSV'       => 0,
        'Try::Tiny'       => 0,
        'URI::Find'       => 0,
        'perl'            => '5.016',
    },
    TEST_REQUIRES => {
        'Test::More'             => 0,
        'Test::RequiresInternet' => 0,
    },
);
