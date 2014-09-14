use t::Helper;
use Cwd 'abs_path';
use File::Spec::Functions 'catdir';

$ENV{PATH} = join ':', grep $_, abs_path(catdir qw( t bin )), $ENV{PATH};

{
  use Mojolicious::Lite;
  plugin 'JQuery';
  get '/js' => sub {
    my $c = shift;
    $c->render(text => $c->asset('jquery.js'));
  };
}

my $t = Test::Mojo->new;

$t->get_ok('/js')->status_is(200);
my $js = $t->tx->res->dom->at('script')->{src};

$t->get_ok($js)
  ->status_is(200)
  ->content_like(qr{v2\.(\d+)\.(\d+)}, 'jquery-2.x.js')
  ;

SKIP: {
  mkdir 'lib/Mojolicious/Plugin/JQuery/packed';
  skip "Could not create lib/Mojolicious/Plugin/JQuery/packed: $!", 5 unless -d "lib/Mojolicious/Plugin/JQuery/packed";
  shift @{ $t->app->static->paths };
  is int(@{ $t->app->static->paths }), 1, 'only one static path';
  
  opendir(my $DH, 't/public/packed') or die $!;
  for(readdir $DH) {
    next unless /^jquery-/;
    unlink "lib/Mojolicious/Plugin/JQuery/packed/$_";
    link "t/public/packed/$_", "lib/Mojolicious/Plugin/JQuery/packed/$_" or die "link t/public/packed/$_: $!";
    unlink "t/public/packed/$_" or die "unlink t/public/packed/$_: $!";
  }

  $t->get_ok($js)->status_is(200);
}

done_testing;
