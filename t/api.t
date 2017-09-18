#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 5;

my $module = 'App::YtDescLinks::API';

eval "use $module";
ok !$@, 'Cannot load API' or BAIL_OUT;

can_ok $module, 'request_description_and_thumbnails' or BAIL_OUT;

my $vid = 'Ks-_Mh1QhMc';
$module->can('api_key')->($ENV{YT_API_KEY});

my ($desc, $thumb) = $module->can('request_description_and_thumbnails')->($vid);
like $desc, qr/body language/i, 'description contains expected phrase';
ok ref($thumb), 'thumbnail is a hashref';
like $thumb->{maxres}->{url}, qr/default.jpg/, 'thumbnail URL is an image';
