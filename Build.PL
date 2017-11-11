use 5.016;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
  module_name         => 'App::WatchLater',
  license             => 'mit',
  dist_author         => q{Aaron L. Zeng <me@bcc32.com>},
  dist_version_from   => 'lib/App/WatchLater.pm',
  release_status      => 'stable',
  configure_requires => {
    'Module::Build' => '0',
  },
  build_requires => {
    'Test::More' => '0',
  },
  requires => {
    'DBI'             => 0,
    'DBD::SQLite'     => 0,
    'HTTP::Tiny'      => '0.055',
    'IO::Socket::SSL' => 0,
    'JSON'            => 0,
    'Text::CSV'       => 0,
    'Try::Tiny'       => 0,
    'URI::Find'       => 0,
    'perl'            => '5.016',
  },
  test_requires => {
    'Test::More'             => 0,
    'Test::RequiresInternet' => 0,
  },
  add_to_cleanup     => [ 'App-WatchLater-*' ],
);

$builder->create_build_script();
