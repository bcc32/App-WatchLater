#!/usr/bin/env perl
use strict;
use warnings;

use ExtUtils::MakeMaker;

my @scripts = <bin/*>;

WriteMakefile(
    AUTHOR        => ['Aaron L. Zeng <me@bcc32.com>'],
    ABSTRACT_FROM => 'lib/API/YouTube.pm',
    NAME          => 'API::YouTube',
    VERSION_FROM  => 'lib/API/YouTube.pm',
    EXE_FILES     => \@scripts,
);
