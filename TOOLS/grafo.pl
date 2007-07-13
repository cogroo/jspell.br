#!/usr/bin/perl -w

use strict;
use warnings;
use GraphViz::Makefile;


#while (<>){ #perl grafo.pl makefile
#    if (/^([^\#\s]+):/){
	my $a="chuveiro";
	my $gm = GraphViz::Makefile->new(undef,"/home/ruivilela/natura/dicionarios/jspell.pt/makefile");
        $gm->generate($a);
	$gm->GraphViz->as_png("$a.png");
#    }
#}
