#!/usr/bin/perl

while (<>) {
    chop;
    s/;/#/;
    next if /^\s*$/;
    next if /\#noispell/;
    s/flag +\+/flag */;
    s/^\#ispell //;
    if(/^\#/) {
        print "$_\n";
    }
    else {
        @x = split(/\//,$_,5); 
        ($word,$cat,$flag,$com) = @x ;
        if(@x>=2) {
            print "$word/$flag\n" unless ($word =~ /\#/);
        }
        else {
            print "$_\n";
        }
    }
}
