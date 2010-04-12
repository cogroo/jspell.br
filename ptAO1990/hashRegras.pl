#!/usr/bin/perl -w
#RegrasSubst -> HashRegrasSubst

#Rui Vilela, 2010

use strict;
use warnings;
use locale;
use Data::Dumper;


my $old; my $ra; my $new;

my %h;

while(<>){
    chomp;
    if (m~([^/]+)\/(?:[^/]*)\/([^/]+)~){
	#print "$1 $2\n";
	$h{$1}=$2;
    }
    else
    {
	die "$_\n";
    }
}

print Dumper \%h;
