#!/usr/bin/perl -w

#Generates PT MySpell dictionary from PT JSpell & ISpell
#Last version 19/01/2005

use strict;
use locale;

my $pri; my $seg; my @ter; my @qua; my @qui; my $i; my $tmp; my $tmp2; my $flg; 

print "SET ISO8859-1\n";
#linha a seguir gerada dinamicamente (lista de letras ordenadas pelo número de ocorrências
print "TRY aerisontcdmlupvgbfzáhçqjíxãóéêâúõACMPSBTELGRIFVDkHJONôywUKXZWQÁYÍÉàÓèÂÚ\n\n";


while(<>){
    next if (/^wordchars/ || /^\s+$/ || /^\#/ || /^defstringtype/ || /^allaffixes/ );
    if (/^prefixes$/){$pri='PFX';next;}
    if (/^suffixes$/){$pri='SFX';next;}
    if (/^flag ([\*\+]?)(\w)/) {    ##Flag data
	$tmp=$2;
	$tmp2=$1;
	
	if (defined($seg)){
	    printf ("\n%s %s %s %d\n",$pri,$seg,$flg=~/[*+]/ ? 'Y' : 'N',$#ter+1); ##number of items
	    for ($i=0;$i<@qui;$i++){
		print "$pri $seg   ".lc($ter[$i])." " x (15-length($ter[$i])).lc($qua[$i])." " x (15-length($qua[$i])).lc($qui[$i])."\n";
	    }
	    @ter=();@qua=();@qui=();
	}
	$seg=$tmp;
	$flg=$tmp2;
	next;
    }
    s/\#.*//;
    /^(.+)\s*>\s+([\-\w]*)[,]?([\-\w]*)\s*/;   ##Takeoff data
    #print STDERR "$pri : $seg : $2 : $3 : $1\n";
    push @qui, $1;
    $tmp2=$2;
    $tmp=$3;
    if (length($tmp)<1) {
	push @ter, '0';
	push @qua, $tmp2; 
    }else{
	push @ter, $tmp2;
	push @qua, $tmp;
    }
    $ter[-1]=~s/\-//;       ##Cleaning
    $qui[-1]=~s/\s//g;
    $qua[-1]=~s/\-/0/;
}

#Copypaste from upper lines
printf ("\n%s %s %s %d\n",$pri,$seg,$flg=~/[*+]/ ? 'Y' : 'N',$#ter+1); ##number of items
	    for ($i=0;$i<@qui;$i++){
		print "$pri $seg   ".lc($ter[$i])." " x (15-length($ter[$i])).lc($qua[$i])." " x (15-length($qua[$i])).lc($qui[$i])."\n";
	    }
