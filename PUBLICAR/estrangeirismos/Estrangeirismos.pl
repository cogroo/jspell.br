#!/usr/bin/perl -w

#Gera em Latex os estrangeirismos existentes no dicionário

#Rui Vilela 2007

BEGIN {
  $ENV{PATH}="$ENV{PATH}:/usr/local/bin";
}

use POSIX qw(locale_h);
use Data::Dumper;
use Lingua::PT::PLNbase;
use Lingua::Jspell;
setlocale(LC_CTYPE, "pt_PT");
use locale;
use warnings;
use strict;

our $dic = Lingua::Jspell->new('port');

my $cats = $dic->{meta}{_};
my $data = $dic->{meta};

my $lista=shift;

open my $G, "<$lista" || die $!;

my $autor="Proj. Natura (DI-UM), http://natura.di.uminho.pt"; 

my $tit="Lista de estrangeirismos identificados no dicionário de
português\\footnote{Documento gerado automaticamente a partir do
dicionário para o Jspell.}\\\\";

my $out='\documentclass[twocolumn,10pt]{article}'."\n";
$out.='\usepackage[latin1]{inputenc}'."\n";
$out.='\usepackage[portuges]{babel}'."\n";
$out.='\usepackage[left=1cm,top=2cm,bottom=2cm,right=1cm]{geometry}'."\n";
$out.='\usepackage{fancyvrb}'."\n";
$out.='\begin{document}'."\n";

$out.='\title{'.$tit.'}'."\n";
$out.='\author{'.$autor.'}'."\n";
$out.='\date{\today}'."\n";
$out.='\maketitle'."\n";
$out.='\newpage'."\n";

while (<$G>){
    chomp;
    $out.= "\n\n\\textbf{$_}\n";
    &informacaoMorfologica($_) for ($dic->fea($_));
}
close $G;

$out.='\end{document}'."\n";

open my $F, ">estrangeirismos.tex" || die $!;
print $F $out;
close $F;



sub informacaoMorfologica{
    my ($fea)=@_;
    $out.="\n".'\begin{Verbatim}'."\n";
    for (keys %$fea) {
       my $data = (exists($data->{$_})&&exists($data->{$_}{$fea->{$_}})?$data->{$_}{$fea->{$_}}:$fea->{$_});
       my $key = (exists($cats->{$_}))?$cats->{$_}:$_;   
       $out.="$key: $data"."\n";
    }
    $out.="\n".'\end{Verbatim}'."\n";
}
