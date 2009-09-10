#!/usr/bin/perl -w

#Frequência das combinações das flags no dicionário Jspell
#ex: a b 2455
#ex: b c 4333
#
#Rui Vilela, Linguateca 2006

use POSIX qw(locale_h);
setlocale(LC_CTYPE, "pt_PT");
use locale;
use strict;
use warnings;
use Data::Dumper;

our %h;

my $d=shift;
our $DIC;
open $DIC, "<$d" || die $!;

&getFreq;

sub getFreq{
    while (<$DIC>){
	&filtro($_);
	if (m!^[^/]+/([^/]*)/([^/]*)/!){
	    my $g=$1;
	    my $s=$2;
	    next if ($g!~/^[\#]/ || $g=~/\,/); #por agora ignorar o que não é macro
	    $h{$g.'_'.$s}++;
	}
    }

    foreach (reverse sort { $h{$a} <=> $h{$b} } (keys %h)){
	print "$_ =>".$h{$_}."\n";
	
    }
}

sub filtro{
    $_=shift;
    chomp;
    s/\s+\#.*//;
    s/^[\'\#].*//;
    $_;
}
