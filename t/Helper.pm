package t::Helper;
BEGIN { $ENV{MOJO_MODE} ||= 'production' }
use Mojo::Base -strict;
use Test::Mojo;
use Test::More;
use File::Basename ();
use File::Find;
use File::Path ();
use File::Spec::Functions qw( catdir catfile splitdir );
use constant DEBUG => $ENV{MOJO_JQUERY_DEBUG} || 0;

my $base = catdir qw( lib Mojolicious Plugin JQuery );

sub copy {
    my $class = shift;

    find(
        {   follow   => 1,
            no_chdir => 1,
            wanted   => sub {
                return unless -f;
                my $file    = $_;
                my $name    = File::Basename::basename($file);
                my $to_dir  = $class->file_to_dir($file) or return;
                my $to_file = catfile $to_dir, $name;

                warn "[TEST] cp $file $to_file\n" if DEBUG;
                File::Path::make_path($to_dir)
                    or die "mkdir $to_dir: $!"
                    unless -d $to_dir;
                unlink $to_file if -e $to_file;
                link $file => $to_file or die "cp $file $to_file: $!";
            },
        },
        'assets',
    );
}

sub file_to_dir {
    my ( $class, $file ) = @_;
    my @path = splitdir $file;

    pop @path unless -d $file;

    while (@path) {
        my $p = shift @path;
        last if $p eq 'stylesheets';
    }

    return catdir $base, 'js' if $file =~ /\.js$/;
    return;
}

sub import {
    my $class  = shift;
    my $caller = caller;

    strict->import;
    warnings->import;

    mkdir catdir qw( t public );
    mkdir catdir qw( t public/packed );

    if ( -d 'assets' ) {
        $base = catdir 'blib', $base if -d 'blib';
        mkdir $base;
        plan skip_all => "Could not create $base: $!" unless -d $base;
        $class->copy;
    }

    eval qq[
    package $caller;
    use Test::More;
    use Test::Mojo;
    1;
  ] or die $@;
}

1;
