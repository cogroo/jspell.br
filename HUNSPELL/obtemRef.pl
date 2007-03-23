#!/usr/bin/perl -w

#Extrai as macros o jspell para uma hash
#obtemRef: Dic -> P(Ref)

#Rui Vilela, 2007

use strict;
use locale;
use Data::Dumper;

my %h;

while(<>){
    chomp;
    next if /^\#\#/;
    next if /\#noispell/;
    $h{"$1"}="$2" if m!^\#([^/]+)/([^/]+)!;
}

print Dumper \%h;
