#!/usr/bin/perl -w

#Substitui todas as macros, e gera um novo dicionário (expande)
#expandeRef: Dic * P(Ref) -> Dic

#Rui Vilela, 2007

use strict;
use locale;
use Data::Dumper;

my $h = do shift;

while(<>){
    next if /^\#/;
    next if /\#noispell/;
    next if /^\s+$/;
    s/\#([\d\w]{1,4})([\,\$\/])/$h->{$1}$2/g;
    s/\#.+$//;
    print;
}
