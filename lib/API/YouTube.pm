#!/usr/bin/env perl
use 5.016;
use warnings;
use autodie;

package API::YouTube;

=head1 NAME

API::YouTube - access the YouTube API

=head1 SYNOPSIS

    my $api = API::YouTube->new(
        access_token => ...,
        api_key      => ...,
    );
    # returns the body of the HTTP response as a string
    $api->request('GET', '/videos', { id => 'Ks-_Mh1QhMc', part => 'snippet' });

=head1 DESCRIPTION

This is a simple module for making requests to the YouTube Data API.
Authorization is required, and can be obtained by registering for an API key
from the Google Developer L<API
Console|https://console.developers.google.com/apis/credentials>. Alternatively,
obtain user authorization through OAuth2 using the yt-oauth(1) script.

=cut

BEGIN {
    require Exporter;
    our @ISA = qw(Exporter);

    our @EXPORT    = ();
    our @EXPORT_OK = ();

    use version; our $VERSION = version->declare('v0.4.1');
}

use Carp;
use HTTP::Tiny;
use JSON;

BEGIN {
    my ($ok, $why) = HTTP::Tiny->can_ssl;
    croak $why unless $ok;
}

our $http = HTTP::Tiny->new;

=head1 CONSTANTS

=head2 VIDEO_ID_REGEX

A pattern that matches YouTube video IDs.

=cut

use constant VIDEO_ID_REGEX => qr/[a-z0-9_-]+/i;

=head1 METHODS

=head2 new

    my $api = API::YouTube->new(%opts)

This constructor returns a new API::YouTube object. Attributes include:

=over 4

=item *

C<api_key> - an API key

=item *

C<access_token> - an OAuth2 access token

=back

At least one of C<api_key> and C<access_token> must be provided. If both are
provided, C<access_token> is used for authorization.

=cut

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

=head2 request

    my $body = $api->request($method, $endpoint, %params);

Send a request to the specified API endpoint using the given HTTP method. Query
parameters may be specified in C<%params>. Croaks if the request fails.

=cut

sub request {
    my ($self, $method, $endpoint, %params) = @_;
    my $url = 'https://www.googleapis.com/youtube/v3' . $endpoint;

    my %headers;

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

=head2 get_video

    my \%snippet = $api->get_video($video_id);

Retrieves a YouTube video resource, including the snippet, for the video given
by C<$video_id>. Croaks if no such video is found.

=cut

sub get_video {
    my ($self, $video_id) = @_;
    my $json = $self->request(
        'GET', '/videos',
        id   => $video_id,
        part => 'snippet',
    );
    my $obj = decode_json($json);
    my $item = $obj->{items}[0] or croak "no video with id $video_id";
    $item->{snippet};
}

1;

=head1 AUTHOR

Aaron L. Zeng <me@bcc32.com>

=cut
