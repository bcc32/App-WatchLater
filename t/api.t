#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 5;

use constant VIDEO_ID => 'Ks-_Mh1QhMc';

my $module;

BEGIN {
    $module = 'API::YouTube';
    use_ok($module);
}

my @methods = qw(new get_video);

can_ok $module, $_ or BAIL_OUT for (@methods);

my $api = new_ok($module => [ api_key => $ENV{YT_API_KEY} ]);

my $snippet = $api->get_video(VIDEO_ID);

like $snippet->{title}, qr/body language/i, 'title contains expected phrase';
