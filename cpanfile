requires 'perl', '5.010001';
requires "Mojolicious", "6.00";
requires "Mojolicious::Plugin::AssetPack", "0.68";
requires "Mojolicious::Plugin::AssetPack::Backcompat", "1.21";
requires "File::Find", "1.07";
requires "File::Basename", "2.0";
on test => sub {
    requires 'Test::More', '0.96';
};
