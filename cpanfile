requires 'perl', '5.010001';
requires "Mojolicious" => "5.00",
requires "Mojolicious::Plugin::AssetPack" => "0.31",
requires "File::Find",
requires "File::Basename",
on test => sub {
    requires 'Test::More', '0.96';
};
