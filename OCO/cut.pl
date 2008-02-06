#!/usr/bin/perl -w

use locale;
use strict;
use warnings;

while (<>){
    s/(.*)/\L$1/;
    if (/\s*(\d+) [[:alpha:]\-]+$/){
    	print;
    }elsif(/\+/){
	print if s/a\+o/ao/;
	print if s/de\+([oa])/"d".$1/e;
	print if s/em\+([oa])/"n".$1/e;
	print if s/em\+isso/nisso/;
	print if s/em\+um/num/;
	print if s/de\+este/deste/;
	print if s/em\+este/neste/;
	print if s/de\+esse/desse/;
	print if s/em\+esse/nesse/;
	print if s/de\+aquele/daquele/;
	print if s/em\+aquele/naquele/;
	print if s/de\+el([ae])s/"del".$1."s"/e;
	print if s/em\+outr([ao])/"noutr".$1/e;
	print if s/de\+outr([ao])/"doutr".$1/e;
	print if s/a\+a/à/;
	print if s/por\+([oa])/"pel".$1/e;
	print if s/em\+el([ea])/"nel".$1/e;
	print if s/de\+aqui/daqui/;
    }
}
