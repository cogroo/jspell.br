#!/usr/bin/perl
#Obtains a list of dictionary letters, sorted by ocurrence #reads a dic file

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
    #print "$_ -> $p{$_}\n";
    print "$_";
}
