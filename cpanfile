requires 'perl', '5.008005';

# requires 'Some::Module', 'VERSION';

requires "Mojolicious" => "5.00",
requires "Mojolicious::Plugin::AssetPack" => "0.21",
requires "File::Find",
requires "File::Basename",
on test => sub {
    requires 'Test::More', '0.96';
};

