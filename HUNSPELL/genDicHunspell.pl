#!/usr/bin/perl -w

#Converts Jspell dictionary to Hunspell Dic for Portuguese (pt_PT)
#GenerateHunspellAffixFile: Jspell Dic -> Hunspell Dic

#É preciso formatar a informação morfológica...

#Rui Vilela, 2007

use strict;
use locale;

while(<>){
    chomp;
	next if m!^\s*$!;
    my ($word, $morf, $flags) = split m!/!;
    die $_ unless $word && $morf && defined($flags);
    print "$word".($flags=~/^\s*$/ ? '':'/')."$flags\t[$morf]\n";
#    print "$word/$flags\t[$morf]\n";
}
