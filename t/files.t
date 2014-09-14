use t::Helper;

{
  use Mojolicious::Lite;
  plugin 'JQuery', migrate => 1;
}

my $t = Test::Mojo->new;

for my $file (qw(
  /js/jquery-2.x.js
  /js/jquery-migrate.js
)) {
  $t->get_ok($file)->status_is(200);
}

done_testing;
