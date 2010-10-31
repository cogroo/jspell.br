#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

my $out = `ispell -d out/ispell-preao/portugues-preao.hash -l < t/formas.cetempublico.txt`;

is($out,"");
