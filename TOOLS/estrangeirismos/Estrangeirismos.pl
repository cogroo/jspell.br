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
use Encode qw/decode/;

our $dic = Lingua::Jspell->new('port');

my $cats = $dic->{yaml}{META}{PROPS};
my $data = $dic->{yaml};

my $lista=shift;

open my $G, "<$lista" || die $!;

my $autor="Proj. Natura (DI-UM), http://natura.di.uminho.pt"; 

my $tit="Lista de estrangeirismos existentes no dicionário de
português\\footnote{Documento gerado automaticamente a partir do
dicionário português para Jspell.}\\\\";

my $out='\documentclass[10pt]{article}'."\n";
$out.='\usepackage[latin1]{inputenc}'."\n";
$out.='\usepackage[portuges]{babel}'."\n";
$out.='\usepackage[left=1cm,top=2cm,bottom=2cm,right=1cm]{geometry}'."\n";
$out.='\usepackage{fancyvrb}'."\n";
$out.='\usepackage{multicol}'."\n";
$out.='\begin{document}'."\n";

$out.='\title{'.$tit.'}'."\n";
$out.='\author{'.$autor.'}'."\n";
$out.='\date{\today}'."\n";
$out.='\maketitle'."\n";
$out.='Línguas de origem dos estrangeirismos:'."\n";
$out.='RRRR'."\n";

$out.='\newpage'."\n";

$out.='\begin{multicols}{3}{'."\n";

my %orig;

while (<$G>){
    chomp;
    my $w=$_;
    for my $c ($dic->fea($_)){
	$orig{$c->{'ORIG'}}++;
	&informacaoMorfologica($c,$w);
    }
}
close $G;

my $orig;
for (sort {$orig{$b} <=> $orig{$a}} keys %orig){
    $orig .= decode ("utf-8", $data->{ORIG}{$_})."(".$orig{$_}."), ";
}
$out=~s/RRRR/$orig/;
$out=~s/,\n$/\n/;

$out.="}\n".'\end{multicols}'."\n";
$out.='\end{document}'."\n";

open my $F, ">estrangeirismos.tex" || die $!;
print $F $out;
close $F;



sub informacaoMorfologica{
    my ($fea,$w)=@_;
    $out.="\n\n".'\begin{Verbatim}[commandchars=\\\\\{\}]'."\n";
    $out.="\\emph{\\textbf{$w}}\n";
    for (keys %$fea) {
       my $data = decode ("UTF-8", (exists($data->{$_})&&exists($data->{$_}{$fea->{$_}})?$data->{$_}{$fea->{$_}}:$fea->{$_}));
       my $key = decode ("UTF-8", (exists($cats->{$_}))?$cats->{$_}:$_);
       next if (/^rad$/); #ignorar lema
       $out.=" $key: $data"."\n";
    }
    $out.="\n".'\end{Verbatim}'."\n";
}
