#!/usr/bin/perl -w

# Rui Vilela 2007
# Procura palavras que foram novamente reintroduzidas no dicionário sem serem consideradas válidas.

use strict;
use locale;
use warnings;
use Data::Dumper;

my $w=shift;
my $v=shift;

die $! unless -d $w;
die $! unless -e $v;

opendir(my $D, "$w") || die $!;
foreach my $name (sort readdir($D)) {
    print "found file: $name\n";
}
closedir($D);

