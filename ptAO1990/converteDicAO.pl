#!/usr/bin/perl -w
#Rui Vilela, 2010

use strict;
use warnings;
#setlocale(LC_CTYPE, "pt_PT");
use locale;
use Data::Dumper;

#organizar leitura dos ficheiros e dos param.

#Lê do port.dic (gerado) e aplica conversão sobre o mesmo ficheiro!
#PRIMEIRO: make jspell



my $h = do shift; #hash
#print Dumper $h;

my $f = shift; #dic
my $AO90; my $grafAlt; my $grafFut ; my $o;

open (F, "<$f");
while(<F>){
    if (m~^([\w\-]+)/([^/]+)/(\w+)~){
	my ($lema, $cg, $ra)=($1,$2,$3);
	if (defined ($h->{$lema})){
	    #AO Style
	    $AO90=1;
	    $AO90='tr' if ($lema=~/-/);
	    $grafAlt=''; #Casos de dupla grafia
	    #Mix Style
	    #
	    #PreAO
	    #$grafFut='';
	    my @ng = split (/,/, $h->{$lema});
	    #Find any CG that has lemma, and needs updating
	    if ( $cg =~ m/\$([\w\-]+)\$/ ){ ## Está a saltar letras ISO88591
		my $w = $1;
		if ( defined ($h->{$w} )) {
		    my @l = split ( /,/,$w); #ignorar dupla grafia
		    $w = shift ( @l );
		    $cg=~s/\$([\w\-]+)\$/\$$w\$/;
		    ####
		} 
	    }
	    unless (defined ($ng[1])){ #Dupla grafia
		$o=$ng[0]."/AO90=$AO90,$cg";
		print "$e/$cg/$ra\n";
	    }else{

	    }
	    
	}else{
	    print;
	}
    }else{
	print;
    }
}
close (F);



