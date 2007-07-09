#!/usr/bin/perl -w

#Gera em latex tabelas de conjungação verbal a partir do Jspell (irregulares)

#Rui Vilela 2007

#@verbos - verbos a processar
#O Verbo bem-querer não é processado
#Os warnings do latex devem-se ao espaço adicionado ao final de cada linha

BEGIN {
  $ENV{PATH}="$ENV{PATH}:/usr/local/bin";
}

use POSIX qw(locale_h);
use Data::Dumper;
use Lingua::PT::PLNbase;
use Lingua::Jspell;
setlocale(LC_CTYPE, "pt_PT");
use locale;
use strict;

our $cats = {};
our $data;

our @ordem_verbos=qw/p pi pp pmp f c pc pic fc i ip inf g ppa/;

our $dic = Lingua::Jspell->new("port");

##########################################################################################################

$cats = $dic->{meta}{_};
$data = $dic->{meta};

################################################################################################

#on makefile
#cat port.geral.dic |grep 'I=' |perl -npe 's/([^\/]+).*/$1/' |xargs

our @verbos;

my $verbos=shift;
open my $G, "<$verbos" || die $!;

while (<$G>){
    chomp;
    push @verbos, $_;
}
close $G;

##################################################################################################

my $autor="Proj. Natura (DI-UM), http://natura.di.uminho.pt"; 

my $tit="Tabelas de conjugação de verbos irregulares
portugueses\\footnote{Documento gerado automaticamente a partir do
dicionário Jspell para português.}\\\\";

my $out='\documentclass[10pt]{article}'."\n";
$out.='\usepackage[latin1]{inputenc}'."\n";
$out.='\usepackage[portuges]{babel}'."\n";
$out.='\usepackage[left=1cm,top=2cm,bottom=2cm,right=1cm]{geometry}'."\n";
$out.='\begin{document}'."\n";

$out.='\title{'.$tit.'}'."\n";

$out.='\author{'.$autor.'}'."\n";

$out.='\date{\today}'."\n";

$out.='\maketitle'."\n";

$out.='\newpage'."\n";
$out.=&TVerb.'\end{document}'."\n";

open my $F, ">tabVerbI.tex" || die $!;
print $F $out;
close $F;

sub TVerb{
    my $o='';
    my $m=0;
    for (@verbos){
	$o.='\begin{tabular}{|p{6cm}|p{6cm}|p{6cm}|}'."\n";
	$o.='\hline';
	$o.='\multicolumn{3}{|c|}{Conjugação do verbo \emph{'.$_.'}} \\\\'."\n";
	$o.='\hline'."\n";
	
	$o.=&gerarTabelaVerbos($_)."\n";
	$o.='\end{tabular}'."\n";
	$o.='\newpage'."\n";
	print ".. ".$m if ($m++ % 20 == 0);
    }
    print "\n";
    $o;
}



sub gerarTabelaVerbos{
    my ($vv)=@_;
    my %t; my $o;
    foreach my $vb ($dic->der($vv)){
  	next if $vb=~/\-/; #ignorar enclíticos para a tabela
	#print STDERR "\n".$fea->{rad}."!".$vb;
	foreach my $fb ($dic->fea($vb)){ #Para cada features de uma palavra
	    next if $fb->{'CAT'}!~/^v$/; #Não considerar o que não é verbo
	    next if ($fb->{'rad'} ne $vv || defined($fb->{'PFSEM'})); #Verificar se é o mesmo lema e se não contém prefixo semântico
	    #print STDERR Dumper $fb if ($vb eq 'gripar');
	    $fb->{'T'}='Z' unless (defined($fb->{'T'})); #Subsititui empty string por algo
	    $fb->{'N'}='Z' unless (defined($fb->{'N'})); #Subsititui empty string por algo
	    $fb->{'P'}='Z' unless (defined($fb->{'P'})); #Subsititui empty string por algo
	    
	    #print STDERR Dumper $fb if ($vb eq 'gripar');
	    my @T1; my @N1; my @P1;
	    @T1=split /\_/, $fb->{'T'}; #Split dos _ retornados pelo Jspell
	    @N1=split /\_/, $fb->{'N'};
	    @P1=split /\_/, $fb->{'P'};
	    foreach my $A (@T1){
		foreach my $B (@N1){
		    foreach my $C (@P1){
			push @{$t{$A}{$B}{$C}}, $vb;
		    }
		}
	    }
	    #print STDERR "ATENÇÃO: ".$& if $_->{'P'}=~/\_/;
	}
    }
    
    #completar Infinitivo Pessoal, e futuro do conjuntivo;
    if (defined ($t{inf}{Z}{Z})){
	my $i=$t{inf}{Z}{Z}[0];
	push @{$t{ip}{s}{1}}, $i;
	push @{$t{ip}{s}{3}}, $i;
	unless (defined($t{fc}{s}{1})){
	    push @{$t{fc}{s}{1}}, $i; 
	    push @{$t{fc}{s}{3}}, $i;
	}
	unless (defined($t{ip}{s}{2})){
	    push @{$t{ip}{s}{2}}, $i.'es';
	    push @{$t{ip}{p}{1}}, $i.'mos';
	    push @{$t{ip}{p}{2}}, $i.'des';
	    push @{$t{ip}{p}{3}}, $i.'em';
	}
	
    }

    #Tabela de Conjugação Verbal
    for (my $c=0;$c<=$#ordem_verbos;$c++){
	unless ($c % 3){
	    if (!$c || !($c % 3)){
		$o.=($c?"\\\\":'')."\n".'\hline'."\n";
		$o.="\n".'\textbf{'.ucfirst($data->{'T'}{$ordem_verbos[$c]})."}";
		$o.='&\textbf{'.ucfirst($data->{'T'}{$ordem_verbos[$c+1]})."}";
		if (defined ($ordem_verbos[$c+2])){
		    $o.='&\textbf{'.ucfirst($data->{'T'}{$ordem_verbos[$c+2]})."}";
		}else{
		    $o.='&-';
		}
		$o.="\\\\\n";
		$o.='\hline'."\n";
	    }
	    #print Dumper \%t;
	    $o.="\n";
	}
	my $e;
	$e='&' if ($c%3);
	$e.='\begin{minipage}[0]{6cm}';
	foreach my $nu (reverse sort keys (%{$t{$ordem_verbos[$c]}})){
	    foreach my $pe (sort keys %{$t{$ordem_verbos[$c]}{$nu}}){
		map {$e.="$_/"} @{$t{$ordem_verbos[($c)]}{$nu}{$pe}};
		$e=~s~/$~\\\\~;
	    }
	}
	#$e=~s~\\\\$~~;
	$e.='\end{minipage}';
	$o.=$e;
    }	
    $o.="&-\\\\\n".'\hline'."\n";
    $o;
}

