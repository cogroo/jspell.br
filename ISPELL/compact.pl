#/usr/bin/perl -w

use locale;
use warnings;
use strict;

#Junta as palavras duplicadas e soma as regras de afixação

my %h;

while (<>){
    chomp;
    if (m!^([^/]+)/?(\w+)?$!){
	$h{$1}=(defined ($h{$1}) ? $h{$1} : '' ).(defined($2) ? "$2" : '' );
    }
}

my %d;

for (sort keys %h){
    $h{$_}=~s/(\w)\1/$1/g; #remove regras duplicadas
    print "$_".($h{$_} ne '' ? "/" : '').$h{$_}."\n";
}
