#!/usr/bin/perl -w

#Converts Jspell dictionary to Hunspell Dic for Portuguese (pt_PT)
#GenerateHunspellAffixFile: Jspell Dic -> Hunspell Dic

#É preciso formatar a informação morfológica...

#Rui Vilela, 2007

use strict;
use locale;

while(<>){
    chomp;
    my ($word, $morf, $flags) = split m!/!;
    print "$word/$flags\t[$morf]\n";
}
