#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 5;

my $dir;
BEGIN {
    use FindBin;
    $dir = $FindBin::Bin . '/../lib/';
}
use lib $dir;

eval "use API";
ok !$@, "Cannot load API" or BAIL_OUT;

can_ok 'API', 'request_description_and_thumbnails' or BAIL_OUT;

my $vid = 'Ks-_Mh1QhMc';
{
    no warnings qw(once);
    $API::KEY = $ENV{YT_API_KEY};
}

my ($desc, $thumb) = &API::request_description_and_thumbnails($vid);
like $desc, qr/body language/i, 'description contains expected phrase';
ok ref($thumb), 'thumbnail is a hashref';
like $thumb->{maxres}->{url}, qr/default.jpg/, 'thumbnail URL is an image';
