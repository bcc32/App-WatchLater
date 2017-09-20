#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 6;

use constant VIDEO_ID => 'Ks-_Mh1QhMc';

my $module;

BEGIN {
    $module = 'API::YouTube';
    use_ok($module);
}

can_ok $module, 'new' or BAIL_OUT;
can_ok $module, 'request_description_and_thumbnails' or BAIL_OUT;

my $api = new_ok($module => [ api_key => $ENV{YT_API_KEY} ]);
my ($desc, $thumb) = $api->request_description_and_thumbnails(VIDEO_ID);

like $desc, qr/body language/i, 'description contains expected phrase';
like $thumb->{maxres}->{url}, qr/default.jpg/, 'thumbnail URL is an image';
