#!/usr/bin/perl

use warnings;
use strict;

use jspell;

my $DIC = jspell::new("./port.hash");
my $port_dic_word_list = load_word_list("port.dic");
my $port_dic_generated;

for my $w (@$port_dic_word_list) {
  print STDERR "$w\n";
  my @der = $DIC->der($w);
  $port_dic_generated->{$_}++ for (@der);
}

printf "Number of words on port.dic: %d\n", scalar(@$port_dic_word_list);
printf "Number of derived words: %d\n", scalar(keys %$port_dic_generated);

sub load_word_list {
  my $file = shift;
  my $wl;
  open F, $file;
  while (<F>) {
    chomp;
    next if m!^#!;
    next if m!^\s*$!;
    s!/.*!!;
    $wl->{$_}++;
  }
  close F;
  return [keys %$wl]
}
