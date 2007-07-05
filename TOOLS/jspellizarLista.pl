#!/usr/bin/perl -w

#Facilita o processamento manual de listas de palavras

#Atenção ao encoding (usar consola em ISO8859-1)

#perl jspellizarLista.pl [qualquer lista de palavras ou de ocorrências]

use POSIX qw(locale_h);
setlocale(LC_CTYPE, "pt_PT");
use locale;
use strict;
use warnings;
use Data::Dumper;

my $cat; my $fl;

my $f=shift;

open my $G,"<$f" or die $!; 

while (<$G>){
    if (/([[:alpha:]-]+)/){
	my $w=$1;
	print "\n ---- Sug: ".`echo $w | jspell -a -z -d port`;
	print "\n ---- Linha: $_\n";
	print "Insert CAT macro (#nm) (Enter to ignore word or '-' to edit elsewhere)\n:";
	chomp ($cat = <STDIN>);
	next if $cat=~/^\s*$/;
	&toEdit($w) && next if $cat=~/-/;
	print "Insert flag (Enter for no flags)\n:";
	chomp ($fl = <STDIN>);
	open my $F, ">>$f.toDic";
	print "\n ---- INSERTING: $w/$cat/$fl/\n";
	print $F "$w/$cat/$fl/\n";
	close ($F);
    }
}

close ($G);

sub toEdit{
    my $w=shift;
    open my $F, ">>$f.toEdit";
    print "\n ---- FOR LATER: $w///\n";
    print $F "$w///\n";
    close ($F);
}
