package Mojolicious::Plugin::JQuery;
use File::Find;
use File::Basename ();

=head1 NAME

Mojolicious::Plugin::JQuery - Mojolicious + http://jquery.com/

=head1 VERSION

2.11002

=head1 DESCRIPTION

L<Mojolicious::Plugin::JQuery> push L<http://jquery.com/>
JavaScript files into your project.

This is done using L<Mojolicious::Plugin::AssetPack>.

=head1 SYNOPSIS

=head2 Mojolicious::Lite

  use Mojolicious::Lite;
  plugin "JQuery";
  get "/" => "index";
  app->start;

=head2 Mojolicious

  sub startup {
    my $self = shift;

    $self->plugin("JQuery");
  }

=head2 Template

  <!doctype html>
  <html>
    <head>
      <meta charset="utf-8">
    <title>class demo</title>
    <style>
      div, span {
          width: 120px;
          height: 40px;
          float: left;
          padding: 10px;
          margin: 10px;
          background-color: #EEEEEE;
    }
    </style>
        %= asset "jquery.js"
    </head>
    <body>
        <div class="notMe">div class="notMe"</div>
  <div class="myClass">div class="myClass"</div>
  <span class="myClass">span class="myClass"</span>
  <script>
    $( ".myClass" ).css( "border", "3px solid red" );
  </script>
    </body>
  </html>

=head1 STATIC FILE STRUCTURE

Following the list of the static files of this project. All js are uncompressed
for developing.

  js/jquery-1.11.1.js
  js/jquery-2.1.1.js
  js/jquery-migrate-1.2.1.js

=head1 Versions installed

This module ship the following version of JQuery and JQuery Migrate:

  jquery-1.11.1.js
  jquery-2.1.1.js
  jquery-migrate-1.2.1.js

=over 4

=item * jquery-migrate

The JQuery migrate plugin allow to use old plugin restoring the deprecated functions
on JQuery 2.x. You can use it simply enabling the migrate option on this plugin.

=back

=cut

use Mojo::Base 'Mojolicious::Plugin';
use File::Spec::Functions 'catdir';
use Cwd ();

our $VERSION = '2.11002';

=head1 METHODS

=head2 asset_path

  $path = Mojolicious::Plugin::JQuery->asset_path();
  $path = $self->asset_path();

Returns the base path to the assets bundled with this module.

=cut

sub asset_path {
    my $class = $_;
    my $path  = Cwd::abs_path(__FILE__);

    $path =~ s!\.pm$!!;

    return $path;
}

=head2 register

  $app->plugin(
    JQuery => {
      migrate => $bool, # default false
      jquery_1 => $bool # default false (prevent migrate inclusion)
    },
  );

Default values:

=over 4

=item * migrate

This will include the last JQuery Migrate version shipped with this plugin.
Set this to 1 if you want to include this js.

=item * jquery_1

This will include the last 1.x.x JQuery version shipped with this plugin.
Set this to 1 if you want to use this version. 
(This option will prevent JQuery Migrate inclusion)

=back

=cut

sub register {
    my ( $self, $app, $config ) = @_;
    my $file_type = "js";

    $app->plugin('AssetPack') unless eval { $app->asset };

    $config->{migrate}  //= 0;
    $config->{jquery_1} //= 0;

    my $location = "/" . $file_type . "/";
    my @files
        = $self->find_files( [ $self->asset_path . '/' . $file_type ],
        $file_type );

    push @{ $app->static->paths }, $self->asset_path;
    $app->asset(
        'jquery.js' => $config->{jquery_1}
        ? ( $location . ( grep /^jquery-1\.(\d+)\.(\d+)\.js$/, @files )[0] )
        : ( $location . ( grep /^jquery-2\.(\d+)\.(\d+)\.js$/, @files )[0] ),
        $config->{migrate} && !( $config->{jquery_1} )
        ? ( $location
                . ( grep /^jquery-migrate-(\d+)\.(\d+)\.(\d+)\.js$/, @files )[0]
            )
        : (),
    );

}

=head2 find_files

  @files = Mojolicious::Plugin::JQuery->find_files($dir,$type);
  @files = $self->find_files($dir,$type);

Search a given file type in all directories of the array.

Required parameters: 

=over 4

=item * $dir

This must be a reference to array of directories where we are looking for
our files.

=item * $type

This is a string of the file's extension that we are looking for.

=back

=cut

sub find_files {
    my $self = shift;
    my $dir  = shift;
    my $type = shift;
    my @files;
    find(
        {   follow   => 1,
            no_chdir => 1,
            wanted   => sub {
                return unless -f;
                push @files, File::Basename::basename($_) if $_ =~ /\.$type$/;
            },
        },
        @{$dir},
    );
    return @files;
}

=head1 CREDITS

L<JQuery|https://github.com/jquery/jquery> is an opensource project with
a lot of L<contributors|https://github.com/jquery/jquery/graphs/contributors>, thank you.

Thanks even to L<jhthorsen|https://github.com/jhthorsen> because this plugin is widely based
on his L<Bootstrap3 plugin|https://github.com/jhthorsen/mojolicious-plugin-bootstrap3>.

=head1 LICENSE

JQuery is licensed under L<MIT|https://github.com/jquery/jquery/blob/master/LICENSE.txt>

This code is licensed under Artistic License version 2.0.

=head1 AUTHOR

Ferro - C<ferro@cpan.org>

=cut

1;
