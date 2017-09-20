#!/usr/bin/env perl
use strict;
use warnings;

package App::YtDescLinks::API;

BEGIN {
    require Exporter;
    our @ISA = qw(Exporter);

    our @EXPORT = ();
    our @EXPORT_OK = ();

    use version; our $VERSION = version->declare('v1.0.0');
}

use Carp;
use HTTP::Tiny;
use JSON;

BEGIN {
    my ($ok, $why) = HTTP::Tiny->can_ssl;
    croak $why unless $ok;
}

our $http = HTTP::Tiny->new;

sub new {
    my ($class, %opts) = @_;

    my $key   = $opts{api_key};
    my $token = $opts{access_token};

    defined $key || defined $token
        or croak "no API key or access token, aborting";

    bless {
        key   => $key,
        token => $token,
    } => $class;
}

sub request {
    my ($self, $method, $endpoint, %params) = @_;
    my $url = 'https://www.googleapis.com' . $endpoint;

    my %headers;

    # TODO document that token overrides
    if (defined $self->{token}) {
        $headers{Authorization} = 'Bearer ' . $self->{token};
    } else {
        $params{key} ||= $self->{key};
    }

    my $query = $http->www_form_urlencode(\%params);
    my $response = $http->request($method, "$url?$query", {
        headers => \%headers,
    });
    croak "$response->{status} $response->{reason}" unless $response->{success};
    $response->{content};
}


sub request_description_and_thumbnails {
    my ($self, $video_id) = @_;
    my $json = $self->request(
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
