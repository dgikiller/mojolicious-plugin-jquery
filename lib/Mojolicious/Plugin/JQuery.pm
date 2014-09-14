package Mojolicious::Plugin::JQuery;

=head1 NAME

Mojolicious::Plugin::JQuery - Mojolicious + http://jquery.com/

=head1 VERSION

2.1.1

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

  js/jquery-1.x.js
  js/jquery-2.x.js
  js/jquery-migrate.js

=head1 Versions installed

This module ship the following version of JQuery and JQuery Migrate:

  jquery-1.11.1.js
  jquery-2.1.1.js
  jquery-migrate-1.2.1.js

=over 4

=item * js/jquery-migrate.js

The JQuery migrate plugin allow to use old plugin restoring the deprecated functions
on JQuery 2.x. You can use it simply enabling the migrate option on this plugin.

=back

=cut

use Mojo::Base 'Mojolicious::Plugin';
use File::Spec::Functions 'catdir';
use Cwd ();

our $VERSION = '2.1.1';

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

    $app->plugin('AssetPack') unless eval { $app->asset };

    $config->{migrate}  //= 0;
    $config->{jquery_1} //= 0;

    push @{ $app->static->paths }, $self->asset_path;
    $app->asset(
        'jquery.js' => $config->{migrate}
            && !( $config->{jquery_1} ) ? ('/js/jquery-migrate.js') : (),
        $config->{jquery_1} ? ('/js/jquery-1.x.js') : ('/js/jquery-2.x.js')
    );

}

=head1 CREDITS

The project L<jquery|https://github.com/jquery/jquery> is an opensource project with
a lot of L<contributors|https://github.com/jquery/jquery/graphs/contributors>

Thanks even to L<jhthorsen|https://github.com/jhthorsen> because this plugin is widely based
on his L<Bootstrap3 plugin|https://github.com/jhthorsen/mojolicious-plugin-bootstrap3>.

=head1 LICENSE

JQuery is licensed under L<MIT|https://github.com/jquery/jquery/blob/master/LICENSE.txt>

This code is licensed under Artistic License version 2.0.

=head1 AUTHOR

Ferro - C<ferro@cpan.org>

=cut

1;
