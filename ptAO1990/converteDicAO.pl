#!/usr/bin/perl -w
#Rui Vilela, 2010

use strict;
use warnings;
use locale;
use Data::Dumper;

#organizar leitura dos ficheiros e dos param.

my $h = do shift; #hash
#print Dumper $h;

my $f = shift; #dic

open (F, "<$f");
while(<F>){
    if (m~^([\w\-]+)/([^/]+)/(\w+)~){
	my ($lema, $cg, $ra)=($1,$2,$3);
	if (defined ($h->{$lema})){
	    for my $e (split (/,/, $h->{$lema})){ #Suporte de dupla grafia...
		#Editar CG, #Editar categorias...
		print "$e/$cg/$ra\n";
	    }
	}else{
	    print;
	}
    }else{
	print;
    }
}
close (F);



