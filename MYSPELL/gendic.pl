#!/usr/bin/perl -w

#Generates PT MySpell dictionary from PT JSpell & ISpell
#Last version2005


use strict;
use locale;

my $pri; my $seg; my @ter; my @qua; my @qui; my $i; my $tmp; my $tmp2; 

print "SET ISO8859-1\n";
print "TRY „·ÈÌıÛÙ‚‡˙Áesianrtolcdugmphbfv\n\n";

while(<>){
    next if (/^wordchars/ || /^\s+$/ || /^\#/ || /^defstringtype/ || /^allaffixes/ );
    if (/^prefixes$/){$pri='PFX';next;}
    if (/^suffixes$/){$pri='SFX';next;}
    if (/^flag [\*\+]?(\w)/) {    ##Flag data
	$tmp=$1;
	if (defined($seg)){
	    printf ("\n%s %s Y %d\n",$pri,$seg,$#ter+1); ##number of items
	    for ($i=0;$i<@qui;$i++){
		print "$pri $seg   ".lc($ter[$i])."\t\t".lc($qua[$i])."\t\t".lc($qui[$i])."\n";
	    }
	    @ter=();@qua=();@qui=();
	}
	$seg=$tmp;
	next;
    }
    s/\#.*//;
    /^(.+)\s*>\s+([\-\w]*)[,]?(\w*)\s*/;   ##Takeoff data
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
}

#Copypaste from upper lines
printf ("\n%s %s Y %d\n",$pri,$seg,$#ter+1);
for ($i=1;$i<@ter;$i++){
    print "$pri $seg   ".lc($ter[$i])."\t\t".lc($qua[$i])."\t\t".lc($qui[$i])."\n";
}
