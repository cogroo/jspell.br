#!/usr/bin/perl -w

#CheckJspell
#Rui Vilela, Linguateca 2006

# -a flags incompactíveis
# -l palavras suspeitas de repetição
# -g verifica falta de categoria gramtical
# -s verifica sintaxe
# -c verifica categoria gramatica, versus flags, com a terminacao da palavra

use POSIX qw(locale_h);
setlocale(LC_CTYPE, "pt_PT");
use locale;
use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use jspell;

our %haf; #Affix file

my %fi=( #Lista de flags mutuamente incompactíveis #Não duplicar informação #Ver freqFlags.pl
     A => [],
     B => [],
     C => [],
     D => [],
     E => [],
     F => [],
     G => [],
     H => [qw/B/], #-mente
     I => [],
     J => [],
     K => [qw/X Y Z/],
     L => [],
     M => [],
     O => [],
     P => [],
     R => [],
     S => [],
     T => [],
     U => [],
     V => [],
     X => [], 
      Y => [],
     Z => [],
     a => [],
     b => [qw /g/],
     c => [qw /C/],
     d => [],
     e => [qw/a/],
     f => [qw /b g/],
     g => [],
     h => [qw /z/],
     i => [],
     j => [],
     m => [qw /H B/],
     n => [],
     o => [],
     p => [qw/a e/],
     q => [],
     r => [],
     s => [],
     t => [],
     u => [],
     v => [],
     w => [],
     x => [],
     y => [],
     z => [],
     y => [],
     );

my %fcv=( #Lista de flags que necessitam uma dada categoria gramatical
       A => { adj => 1 , a_nc => 1},
       d => { adj => 1 , a_nc => 1}, #Para verbos necessita da flag 'v'
       f => { adj => 1 , a_nc => 1, nc => 1}, #nc -> 0 excepção
       j => { adj => 1 , a_nc => 1},
       m => { adj => 1 , a_nc => 1},
       H => { adj => 1 , a_nc => 1},
       B => { v => 1},                #Verbos só com B e não m nem H
       s => { adj => 1 , a_nc => 1},
       U => { adj => 1 , a_nc => 1},
       F => { adj => 1 , a_nc => 1},
       I => { adj => 1 , a_nc => 1},
       T => { adj => 1 , a_nc => 1, nc => 1}, #Adiciomei substantivos
       U => { adj => 1 , a_nc => 1},
       a => { nc =>1, adj => 1 , a_nc => 1},
       h => { nc =>1, adj => 1 , a_nc => 1},
       p => { nc =>1, adj => 1 , a_nc => 1},
       i => { nc =>1, a_nc => 1, adj => 1}, #adicionei adjectivos
       t => { nc =>1, a_nc => 1},
       w => { nc =>1, a_nc => 1},
       y => { nc =>1, a_nc => 1},
       C => { v => 1 },
       c => { v => 1 },
       D => { v => 1 },
       M => { v => 1 },
       n => { v => 1 },
       o => { v => 1 },
       v => { v => 1 },
       L => { v => 1 },
       P => { v => 1 },
       G => { adj => 1 , a_nc => 1,},
       );
              

my $d=''; my $f=''; my $a=0;my $l=0; my $g=0; my $s=0; my $c=0;
GetOptions('d=s' => \$d, 'f=s' => \$f, 'a' => \$a, 'l' => \$l, 'g' => \$g, 's' => \$s, 'c' => \$c);

if (($f eq '' || $d eq '') || !($a || $l || $g || $s || $c)){
    print "Uso: checkJspell.pl (-a|-l|-g|-s|-c) -d DICIONARIO -f AFIXOS\n\n";
    exit;
}elsif (!(-r $f || -r $d)){
    die "Não é possível ler um dos ficheiros !\n";
}

&lerAffixFile($f);
#print Dumper \%haf;

our $dic = jspell::new('port');

our $DIC;
open $DIC, "<$d" || die $!;

if ($a){&checkTerminations}
elsif($l){&checkAcentuadas}
elsif($g){&checkFaltaCatGramatical}
elsif($s){&checkSintaxe}
elsif($c){&ValidarCatGramaticalFlags}
else{die "?"}

sub c{ #comparar string (acentos)
    my $p=shift;
    $p=~tr/áçíãóéêâúõôÁÍÉàÓèÂÚÇ/aciaoeeauooAIEaOeAUC/;
    $p;
}

sub s{
    ($_)=@_;
    s/\s//g;
    $_;
}

#################################################################################

#ler Affix file para lista ?
sub lerAffixFile{
    my ($f)=@_;
    my $F;
 #ignorar valor 1
    open $F, "<$f" || die $!;
    
    my $cflag;
    my $i=-1;
    my $pre=0; #prefixo

    while(<$F>){
	chomp;
	s/\#.*//;
	s/\;.*//;
	next unless length;

	if (/^prefixes$/ ... /^suffixes$/){
	    $pre=1;
	}else{
	    $pre=0;
	}

	if (/flag [\*\+](\w)\:/){
	    $cflag=$1;
	    $i=-1;
	}elsif (/([^>]+)>([^,]+),?(.+)?/ && !/^texchars/){
	    $haf{$cflag}[++$i]{c}=&s($1);
	    $haf{$cflag}[$i]{r}=&s($2);
	    $haf{$cflag}[$i]{p}=&s($3) if defined($3);
	    $haf{$cflag}[$i]{s}=$pre;
	    
	    #print "$&\n";
	}
    }
    close ($F);
}

#Verifica terminação da palavra com a condição da flag
#Também verifica se a flag é válida
sub checkTerminations{
    while (<$DIC>){
	&filtro($_);
	next unless length;
	
	if (m!^([^/]+)/[^/]*/([^/]*)/!){
	    my $word=$1;
	    if (defined ($2)){
		my @f=split //, $2;
		$word =~s/(.*)/\U$1/;
		foreach (@f){
		    print STDERR "Flag '$_' não definida no ficheiro de afixos!\n" unless (defined($haf{$_})); #Check Valid here Flag
		    my $isDefined=0;
		    for my $x (0 .. $#{$haf{$_}}){
#			print STDERR $haf{$_}[$x]{c} if ($.==31);
			if ( $haf{$_}[$x]{s} && $word=~/^$haf{$_}[$x]{c}/ ){ #Prefixos
			    $isDefined++;
			    last;
			}elsif( $word=~/$haf{$_}[$x]{c}$/){ #Sufixos
			    $isDefined++;
			    last;
			}
		    }
		    print STDERR "linha $.: A palavra $word não necessita da flag '$_'\n" unless ($isDefined);
		    for my $l (0 .. $#{$fi{$_}}){
			my $z=$fi{$_}[$l];
			if ($z!~/!/ && grep (/$z/, @f)){
			    print STDERR "linha $.: A flag '$_' é incompactível com '$z' para a palavra '$word'\n";
			}elsif (($z=~s/!//) && grep (!/$z/, @f)){
			    print STDERR "linha $.: A flag '$_' necessita da flag '$z' para a palavra '$word'\n";
			}
		    }
		}
	    }

	}

    }
}

#Repetição de palavras (conflitos de palavras acentuadas ?)
sub checkAcentuadas{
    my $b='';
    while (<$DIC>){
	&filtro($_);	
	next unless length;
	if (m!^([^/]+)!){
	    my $a=$1;
	    #print &c($b)." eq ".&c($a)."\n";
	    if (&c($b) eq &c($a)){
		print STDERR "Linha $.: A palavra (repetida) $b <=> $a\n";	    
	    }else{
		$b=$a;
	    }
	}
    }
}

sub checkFaltaCatGramatical{
    my $b='';
    while (<$DIC>){
	&filtro($_);
	next unless length;
	print STDERR "Linha $.: Falta a categoria gramatical para a palavra $1\n" if (m!^([^/]+)//[^/]*/!)
	     
    }
}

sub checkSintaxe{
    my $b='';
    while (<$DIC>){
	&filtro($_);
	next unless length;
	print STDERR "Linha $.: Erro de sintaxe $_\n" unless (m!^[^/]+/[^/]*/[^/]*/!);
	#Outros casos ?	     
    }
}

sub filtro{
    $_=shift;
    chomp;
    s/\s+\#.*//;
    s/^[\'\#].*//;
    $_;
}

#Flag aplicada tem a respectiva categoria Gramatical ? Detecta ausência de categoria
sub ValidarCatGramaticalFlags{
    $dic->setmode({flags => 0, nm=>0});
    my $l=0;
    while (<$DIC>){
	$l++; #problema com o $. ?
	&filtro($_);
	next unless length;
	if (m!^([^/]+)/[^/]*/([^/]*)/!){
	    my $word=$1;
	    if (defined ($2)){
		my @f=split //, $2;
		$word =~s/(.*)/\U$1/;
		for my $n (@f){
		    next unless defined($fcv{$n});
		    my $val=0;
		    foreach my $m ($dic->fea($word)){
			$m->{rad}=~s/(.*)/\U$1/;
			#print "$word - ".$m->{rad}."\n";
			next if ($word ne $m->{rad});
			for my $o (keys %{$fcv{$n}}){ #ignorar valor 1
			    $val++ if ($o eq $m->{CAT} && $fcv{$n}{$o} eq '1');
			}
		    }
		    print STDERR "Linha $l: Flag $n incompactível com CatG: $_\n" unless ($val); #O número de linha está errado ?
		}
	    }
	}
    }
}

