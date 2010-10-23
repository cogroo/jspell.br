#!/usr/bin/perl -w

#José João Almeida, 2001
#Rui Vilela, 2006
#Asimoes, 2010
#Gera uma lista de palavras flexionadas dos lemas do dicionário

#undef $/;
#$/='';

my $dict = shift or die;
my $hash = shift || "port";

#port.hash actualizado?
open(F,qq{awk -F / '{print \$1 "/" \$3}' $dict | jspell -d $hash -e -o '' |}) or die;
open(F1,"| grep -v '#' |grep '[a-zA-Zàéóáú]' | LC_ALL=C sort -u") or die;

my $i;
while(<F>){
    $i++;
    s/[= ,\n]+/\n/g;

    print STDERR "."      unless $i % 100;
    print STDERR " "      unless $i % 1000;
    print STDERR "[$i]\n" unless $i % 5000;

    next if m!^#!;
    print F1 "$_\n";

}
print STDERR " [$i]\n";

close F1;
close F;

