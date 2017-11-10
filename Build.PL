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
        #'ABC'              => '1.6',
        #'Foo::Bar::Module' => '5.0401',
    },
    add_to_cleanup     => [ 'App-WatchLater-*' ],
);

$builder->create_build_script();
