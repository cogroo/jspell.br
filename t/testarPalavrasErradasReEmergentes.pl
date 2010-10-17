#!/usr/bin/perl -w

# Rui Vilela 2007
# Procura palavras que foram novamente reintroduzidas no dicionário sem serem consideradas válidas.

use strict;
use locale;
use warnings;
use Text::Diff;
use Data::Dumper;

my $w=shift;
my $v=shift;

die $! unless -d $w;
die $! unless -e $v;

opendir(my $D, "$w") || die $!;
my @wlist = grep /\d{4}/, sort readdir($D);
#print Dumper \@wlist;
closedir($D);

#Calcular listas de palavras removidas e adicionadas

my $f1=shift @wlist;
for my $f2 (@wlist){
    my $diff = diff "$w/$f1", "$w/$f2", { STYLE => "Context" };
    print $diff;
    die;
    $f1=$f2;
}
