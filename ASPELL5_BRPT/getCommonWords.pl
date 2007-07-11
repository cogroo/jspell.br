#!/usr/bin/perl -w

#Rui Vilela 2007

#pt_PT.wl * pt_BR.wl -> pt-only.wl * pt_PT-only.wl * pt_BR-only.wl
#Gera 3 Ficheiros

use strict;
use warnings;

my $fpt=shift;
my $fbr=shift;

my $FPT; my $FBR;

open $FPT, "<$fpt" || die $!;
open $FBR, "<$fbr" || die $!;

my %pt;
my %br;

print "Reading pt_PT (8MB)\n";

while(<$FPT>){
    chomp;
    $pt{"$_"}++;
}

print "Reading pt_BR (33MB)\n";

close $FPT;

while(<$FBR>){
    chomp;
    $br{"$_"}++;
}
close $FBR;

my @common;

print "Finding Common words\n";

for (keys %pt){
    if (defined($br{"$_"})){
	push @common,"$_";
	delete $pt{"$_"};
	delete $br{"$_"};
    }
}

print "Writing pt_PT-only\n";

open $FPT, ">pt_PT-only.wl_" || die $!;
print $FPT "$_\n" for (keys %pt);
close $FPT;

print "Writing pt_BR-only\n";

open $FBR, ">pt_BR-only.wl_" || die $!;
print $FBR "$_\n" for (keys %br);
close $FBR;

print "Writing common words\n";

open my $COM, ">pt-only.wl_" || die $!;
print $COM "$_\n" for (@common);
close $COM;


