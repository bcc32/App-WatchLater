#!/usr/bin/env perl
use strict;
use warnings;

use ExtUtils::MakeMaker;

my @scripts = glob 'bin/*';

WriteMakefile(
    AUTHOR        => ['Aaron L. Zeng <me@bcc32.com>'],
    NAME          => 'API::YouTube',
    ABSTRACT_FROM => 'lib/API/YouTube.pm',
    VERSION_FROM  => 'lib/API/YouTube.pm',
    EXE_FILES     => \@scripts,
    PREREQ_PM     => {
        "HTTP::Tiny"      => 0,
        "IO::Socket::SSL" => 0,
        "JSON"            => 0,
    },
);
