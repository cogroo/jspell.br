#!/usr/bin/perl -l -w

#perl retiraRegra.pl [REGRAS] dic

use warnings;
use strict;
use locale;

my $r=shift;

while (<>){
    chomp;
    if (m!^([^/]+)/(\w+)$!){
	my $g=$1;
	my $f=$2;
	$f=~s![$r]+!!;
	$_="$g/$f";
	
    }
    s!/$!!;
    print;
}
