use Mojo::Base -strict;
use Test::Mojo;
use Test::More;
use Mojolicious;

my %mode = map { $_ => rand(100) } qw( production development );

for my $mode ( sort { $mode{$a} <=> $mode{$b} } keys %mode ) {
    diag $mode;
    local $ENV{PATH} = '';
    my $app = Mojolicious->new;
    my $t   = Test::Mojo->new($app);

    $app->mode($mode);
    $app->plugin('JQuery');
    $app->routes->get( '/' => 'index' );

    $t->get_ok('/');

    if ( $mode eq 'production' ) {
        $t->element_exists(qq(script[src^="/packed/jquery-"]));
    }
    else {
        $t->element_exists(qq(script[src^="/js/jquery-2."]));
    }
}

done_testing;

__DATA__
@@ index.html.ep
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
