#!/usr/bin/env perl
use strict;
use warnings;

use ExtUtils::MakeMaker;

my @scripts = (
    'bin/yt-desc-links',
    'bin/yt-oauth',
);

WriteMakefile(
    AUTHOR        => ['Aaron L. Zeng <me@bcc32.com>'],
    ABSTRACT_FROM => 'lib/API/YouTube.pm',
    NAME          => 'App::YtDescLinks',
    VERSION_FROM  => 'lib/API/YouTube.pm',
    EXE_FILES     => \@scripts,
);
