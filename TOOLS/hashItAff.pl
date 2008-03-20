#!/usr/bin/perl -w
#Recolher Afixos
#Rui Vilela, 2008

use strict;
use warnings;
use Data::Dumper;

my %d;
my $g=0;
my $opt;

my $flag;

#Juntar elementos comuns
while(<>){
    chomp;
    next if (/\#noispell/);
    $g++ if (/^prefixes/);
    $g++ if (/^suffixes/);
    next unless $g;
    next if (/^\s*$/ || /^\#/ || /prefixes/ || /suffixes/);
    if (/^flag .(.)/){
	$flag=$1;
	$opt=0;
    }elsif (/([^>]+)>([^,]+),?(.*)?;/){
	$opt++;
	($d{$g}{$flag}{$opt}{con},$d{$g}{$flag}{$opt}{tir},$d{$g}{$flag}{$opt}{por})=(&s($1),&s($2),&s($3));
	#print "$1 .... $2 .... $3\n";
    }
}

print Dumper \%d;

sub s{
    ($_)=@_;
    s/\s+//g; #TUDO!
    $_;
}
