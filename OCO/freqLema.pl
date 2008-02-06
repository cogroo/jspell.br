#!/usr/bin/perl -w

#Devolve a frequência relativa e logaritmo natural dos lemas que estão no dicionário

#uso: perl freqLema.pl dicionário lista_frequências

#Rui Vilela, Linguateca 2006

use locale;
use strict;
use jspell;
use Data::Dumper;

my $dic=shift;
my $freq=shift;
my @d;

open my $F, "<$dic" || die $!;

our $dc = jspell::new('port');

my $ant=''; my $w='';
while(<$F>){
    next unless length;
    next if /^\s*\#/;
    if (/^(\w+)/){
	$w=$1;
	next if ($w eq $ant);
	$ant=$w;
	push @d, $w;
    }
}

my %d;

close ($F);
open $F, "<$freq" || die $!;


my %f;
while (<$F>){ #Put in hash
    $f{$2}+=$1 if (/(\d+) (\S+)$/);
}
close ($F);

my %h;

my $soma;

foreach (@d){
    if (defined ($f{$_})){
	$h{$_}=$f{$_};
	#print $h{$_}."\n" if /^à$/;
	$soma+=$f{$_};
    }
}

print STDERR "Total: $soma\n";

#Ranking baseado em Frequencia Relativa
#foreach (sort {$h{$b}<=>$h{$a}} keys %h){
foreach (sort keys %h){
    print $_ ." ". &ln($h{$_},$soma)."\n";
}

sub ln{ 
    my ($b,$s)=@_;
    my $a=log($b/$s*1e9)/log(10);
    $a*=2;
    my $t=sprintf ("%d", $a);
    return $b." ".$a." ".$t;
}
