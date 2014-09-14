use t::Helper;

{
  use Mojolicious::Lite;
  plugin 'JQuery', jquery_1 => 1;
  get '/js' => sub {
    my $c = shift;
    $c->render(text => $c->asset('jquery.js'));
  };
}

my $t = Test::Mojo->new;

$t->get_ok('/js')->status_is(200)->element_exists('script[src^="/packed/jquery"]');
$t->get_ok($t->tx->res->dom->at('script')->{src})->status_is(200)->content_like(qr{v1\.(\d+)\.(\d+)}, 'jquery-1.x.js');

done_testing;
