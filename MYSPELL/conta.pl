#!/usr/bin/perl
#Obtains a list of dictionary letters, sorted by ocurrence 
#reads an ISPELL dic file

use locale;
while(<>){
    if (/^(\w+)[\/\n]/){
	@st=split //,$1;
	foreach (@st){
	    $p{$_}++;
	   }
    }
}

#sortear ao fim

foreach (sort {$p{$b}<=>$p{$a}} (keys (%p))){
    #print "$_ -> $p{$_}\n";       ##Uncomment this line to get statistics
    print "$_";
}
print "\n";
