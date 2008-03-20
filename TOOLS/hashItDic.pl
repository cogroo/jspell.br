#!/usr/bin/perl -w
#Recolher Words

#Rui Vilela, 2008

use strict;
use warnings;
use Data::Dumper;

my %d;

#Juntar elementos comuns
while(<>){
    next if (/^\s*$/ || /^\#/);
    my ($word,$cat,$flag)=split /\//,$_ || warn "$_\n";
    push @{$d{$word}},$_ foreach (split //,$flag);
}

print Dumper \%d;
