#!/usr/bin/perl -w

use strict;
use locale;
use warnings;
use Data::Dumper;

my $h=do HashFreqDic;

my $nomeCorpus="teste";

while (<>){
    if (/(.+) .+ .+ (.+)/){
	$h->{"$1"}{F}{$nomeCorpus}=$2;
    }
}

print Dumper $h;
