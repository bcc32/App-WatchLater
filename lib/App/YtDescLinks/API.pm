#!/usr/bin/env perl
use strict;
use warnings;

package App::YtDescLinks::API;

BEGIN {
    require Exporter;
    our @ISA = qw(Exporter);

    our @EXPORT = ();
    our @EXPORT_OK = qw(api_key request_description_and_thumbnails);

    use version; our $VERSION = version->declare('v1.0.0');
}

use Carp;
use HTTP::Tiny;
use JSON;
use URI::Escape;

BEGIN {
    my ($ok, $why) = HTTP::Tiny->can_ssl;
    croak $why unless $ok;
}

our $KEY;
our $http = HTTP::Tiny->new;

sub api_key {
    my ($key) = @_;
    if (defined $key) {
        $KEY = $key;
    }
    $KEY;
}

sub request {
    my ($method, $endpoint, $params) = @_;
    my $url = 'https://www.googleapis.com' . $endpoint;
    my $query = '';

    my %params = %$params;
    $params{key} = $KEY;

    for my $key (keys %params) {
        my $val = $params{$key};
        $query .= '&' . uri_escape($key) . '=' . uri_escape($val);
    }

    $query =~ s/^./?/;
    $url .= $query;

    my $response = $http->request($method, $url);
    croak "$response->{status} $response->{reason}" unless $response->{success};
    $response->{content};
}


sub request_description_and_thumbnails {
    my ($video_id) = @_;
    my $json = request('GET', '/youtube/v3/videos', {
        id => $video_id,
        part => 'snippet',
    });
    my $obj = decode_json($json);
    my $item = $obj->{items}[0];
    unless (defined $item) {
        croak "couldn't find video with id $video_id";
        return;
    }
    $item->{snippet}{description}, $item->{snippet}{thumbnails};
}

1;
