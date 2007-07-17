#!/usr/bin/perl -w
#Rui Vilela, 2007

#Processa as variáveis contidas em $, usar com a makefile

use strict;
use warnings;
use Data::Dumper;

my $t=shift;
my $f=shift;
my $g=shift;

#ler metadados

open my $T, "<metadados.$t" || die $!;
my %mt;

while(<$T>){
    chomp;
    if (/^(\S+) (.+)$/){
	$mt{$1}=$2;
    }
}

close $T;

open my $F, "<$f" || die $!;
my $o;

while(<$F>){
    $o.=$_;
}

close $F;

$o=~s/--/\t\t\t\t----------/g;

for (keys %mt){
    my $u=$mt{$_};
    if ($u=~s/\`//g){
	$u=`$u`;
    }
    $o=~s/\$$_\$/$u/gs;
}

$o=~s/\$\$/ /g;
$o=~s/\|/\n/g;
$o=~s/\@/ \(email-a\) /g;

open my $G, ">$g" || die $!;
print $G "$o\n";
close $G;

unlink $f;
