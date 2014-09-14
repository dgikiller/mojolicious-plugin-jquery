use t::Helper;

{
  use Mojolicious::Lite;
  plugin 'JQuery', migrate => 1;
  get '/js' => sub {
    my $c = shift;
    $c->render(text => $c->asset('jquery.js'));
  };
}

my $t = Test::Mojo->new;

$t->get_ok('/js')->status_is(200)->element_exists('script[src^="/packed/jquery"]');
$t->get_ok($t->tx->res->dom->at('script')->{src})->status_is(200)->content_like(qr{migrate}, 'jquery-migrate.js');

done_testing;
