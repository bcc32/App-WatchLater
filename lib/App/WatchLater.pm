package App::WatchLater;

use 5.016;
use strict;
use warnings;

use Carp;
use DBI;
use Getopt::Long qw(:config auto_help gnu_getopt);
use Pod::Usage;

use App::WatchLater::YouTube;

=head1 NAME

App::WatchLater - Manage your YouTube Watch Later videos

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    watch-later [(-a [-n]) | (-w [-m])] [<video-id-or-url>...]

    -a, --add        add videos to the queue (default)
    -n, --no-unmark  don't mark re-added videos as unwatched

    -w, --watch      remove videos from the queue
    -m, --mark-only  only mark videos as watched; don't actually open them in
                     the browser

    -d, --db-path <file>  use the given file as the database (default is
                          ~/.watch-later.db)

    --help     display this help message
    --version  display version info

TODO example code using the module...

=head1 DESCRIPTION

Manages a Watch Later queue of YouTube videos, in case you're one of the kinds
of people whose Watch Later lists get too out of hand. Google has deprecated the
ability to access the B<WL> playlist via the YouTube Data API, which means we
have to go to a bit more effort.

An API key is required to access the YouTube Data API. Alternatively, requests
may be authorized by providing an OAuth2 access token.

=head1 OPTIONS

=head2 Universal Options

=head3 B<-d> <file>, B<--db-path>=<file>

Use the provided file as the database, instead of the default database at
F<$HOME/.watch-later.db>.

=head2 Modes of Operation

=head3 B<-a>, B<--add>

Add videos to the queue. Marks a video as unwatched if it is already in the
database. This the default if no mode is specified.

=head3 B<-w>, B<--watch>

Watch a video from the queue by opening its URL in the browser. Marks the given
video as watched. If no video is provided on the command line, picks one at
random.

=head2 Add Mode

=head3 B<-n>, B<--no-unmark>

Normally, adding a video to the database when it is already present will cause
it to be marked as unwatched. This flag disables that behavior and leaves it in
whatever state it was found.

=head2 Watch Mode

=head3 B<-m>, B<--mark-only>

Normally, watching a video will cause its YouTube URL to be opened in a browser.
This flag causes the video to simply be marked as watched and no browser opened.

=head1 ENVIRONMENT

=over 4

=item YT_API_KEY

Set the YouTube Data API key.

=item YT_ACCESS_TOKEN

Set the OAuth2 access token.

=back

=head1 EXPORT

TODO

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 ensure_schema

TODO

=cut

sub ensure_schema {
  my $dbh = shift;
  $dbh->do(<<'SQL') or die $dbh->errstr;
CREATE TABLE IF NOT EXISTS videos(
  video_id      TEXT PRIMARY KEY,
  video_title   TEXT,
  channel_id    TEXT,
  channel_title TEXT,
  watched       INTEGER NOT NULL DEFAULT 0
);
SQL
}

=head2 add

TODO

=cut

sub add {
  my ($dbh, $api, @video_ids) = @_;

  # FIXME use a transaction
  my $sth = $dbh->prepare_cached(<<'SQL');
INSERT OR REPLACE INTO videos (video_id, video_title, channel_id, channel_title, watched)
VALUES (?, ?, ?, ?, 0);
SQL

  for my $vid (@video_ids) {
    my $snippet = $api->get_video($vid);
    $sth->execute($vid, $snippet->{title},
                  $snippet->{channelId}, $snippet->{channelTitle});
  }
}

=head2 main

TODO

=cut

sub main {
  my $dbpath = "$ENV{HOME}/.watch-later.db";
  my $add = 0;
  my $watch = 0;

  GetOptions(
    'db-path|d=s' => \$dbpath,
    'add|a'       => \$add,
    'watch|w'     => \$watch,
  ) or pod2usage(2);

  die "Add and Watch modes both specified" if $add && $watch;

  my $handler = $watch ? \&watch : \&add;

  my $dbh = DBI->connect("dbi:SQLite:dbname=$dbpath");
  ensure_schema($dbh);

  my $api = App::WatchLater::YouTube->new(
    api_key      => $ENV{YT_API_KEY},
    access_token => $ENV{YT_ACCESS_TOKEN},
  );
  $handler->($dbh, $api, @ARGV);
}

=head1 AUTHOR

Aaron L. Zeng, C<< <me at bcc32.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-watchlater at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-WatchLater>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::WatchLater


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-WatchLater>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-WatchLater>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-WatchLater>

=item * Search CPAN

L<http://search.cpan.org/dist/App-WatchLater/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2017 Aaron L. Zeng.

This program is distributed under the MIT (X11) License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.


=cut

1; # End of App::WatchLater
