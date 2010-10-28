#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

my $out = `jspell -d out/jspell-preao/port-preao.hash -l < t/formas.cetempublico.txt`;

is($out,"");
