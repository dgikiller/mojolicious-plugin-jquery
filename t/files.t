use t::Helper;

{
  use Mojolicious::Lite;
  plugin 'JQuery', migrate => 1;
}

my $t = Test::Mojo->new;

for my $file (qw(
  /js/jquery-2.1.1.js
  /js/jquery-migrate-1.2.1.js
)) {
  $t->get_ok($file)->status_is(200);
}

done_testing;
