#!/usr/bin/env perl
use strict;
use warnings;

package App::YtDescLinks::API;

BEGIN {
    require Exporter;
    our @ISA = qw(Exporter);

    our @EXPORT = ();
    our @EXPORT_OK = qw(api_key access_token request_description_and_thumbnails);

    use version; our $VERSION = version->declare('v1.0.0');
}

use Carp;
use HTTP::Tiny;
use JSON;

BEGIN {
    my ($ok, $why) = HTTP::Tiny->can_ssl;
    croak $why unless $ok;
}

our $KEY;
our $ACCESS_TOKEN;
our $http = HTTP::Tiny->new;

sub api_key {
    my ($key) = @_;
    $KEY = $key if defined $key;
    $KEY;
}

sub access_token {
    my ($access_token) = @_;
    $ACCESS_TOKEN = $access_token if defined $access_token;
    $ACCESS_TOKEN;
}

sub request {
    my ($method, $endpoint, %params) = @_;
    my $url = 'https://www.googleapis.com' . $endpoint;

    my %headers;

    if (defined $ACCESS_TOKEN) {
        $headers{Authorization} = 'Bearer ' . $ACCESS_TOKEN;
    } else {
        $params{key} ||= $KEY;
    }

    my $query = $http->www_form_urlencode(\%params);
    my $response = $http->request($method, "$url?$query", {
        headers => \%headers,
    });
    croak "$response->{status} $response->{reason}" unless $response->{success};
    $response->{content};
}


sub request_description_and_thumbnails {
    my ($video_id) = @_;
    my $json = request(
        'GET', '/youtube/v3/videos',
        id   => $video_id,
        part => 'snippet',
    );
    my $obj = decode_json($json);
    my $item = $obj->{items}[0];
    unless (defined $item) {
        croak "couldn't find video with id $video_id";
        return;
    }
    $item->{snippet}{description}, $item->{snippet}{thumbnails};
}

1;
