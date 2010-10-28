#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

`cat t/formas.cetempublico.txt | iconv -f latin1 -t utf8 > _formas`;

my $out = `hunspell -i utf-8 -d out/hunspell-preao/pt_PT-preao -l < _formas`;

is($out,"");

unlink "_formas";
