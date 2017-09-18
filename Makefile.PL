#!/usr/bin/env perl
use strict;
use warnings;

use ExtUtils::MakeMaker;

my $script = 'bin/App/YtDescLinks/yt-desc-links';

WriteMakefile(
    AUTHOR        => ['Aaron L. Zeng <me@bcc32.com>'],
    ABSTRACT_FROM => $script,
    NAME          => 'App::YtDescLinks',
    VERSION_FROM  => $script,
    EXE_FILES     => [$script],
);
