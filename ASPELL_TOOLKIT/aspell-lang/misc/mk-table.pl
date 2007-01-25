#!/usr/bin/perl

use strict;
use warnings 'all';
no warnings 'uninitialized';
no locale;

# code name script dict gettext

my (%L, %LL, # code => [code, name, scripts, dict, gettext]
    %S);# script => class

my @skip = qw(no);
my @dead = qw(ae cu la pi);
my @minor # population below 100,000 - 200,000
  = qw(ab an bi ch cr dv dz fo gd gv ik iu kl kw mh mi na oj rm sa se);
    # iffy: ho hz nv to ty os
my @minor2 # population below 450,000 - 550,000
  = qw(co fj ga ho hz os sg sm mt nv to ty lb kv kj is eu cy);
my @minor3 # population below 800,000 - 1,000,000
  = qw(oc ve nr ng br av);
my @artif = qw(ie vo fy); # ia eo
my @ignr = (@dead, @minor, @artif);
my @nospace = qw(Thai Lao Khmer);

sub oneof ( $ @ ) {return grep {$_ eq $_[0]} @_[1 .. $#_];}

sub trim ( \@ \@ ) {return grep {oneof $_, @{$_[1]}} @{$_[0]};}

open F, "lang.txt";
while (<F>) {
  my ($c, $l) = /(.+?)\t(.+?)\n/ or die;
  next if oneof $c, @skip;
  $L{$c} = [$c, $l];
};

open F, "scripts.txt";
my $script;
while (<F>) {
  chop;
  next unless /\w/;
  if (/(.+):/) {
    $script = $1;
  } elsif (/(\w+)\s*$/) {
    #next unless length($1) == 2;
    next if oneof $1, @skip;
    die unless $L{$1};
    push @{$L{$1}[2]}, $script;
    $S{$script} = undef;
  } else {
    die unless /(\w+).?\s*/;
  }
}

open F, "class.txt";
my (@alpha, @unsup);
my $class;
while (<F>) {
  chop;
  next unless /\w/;
  if (/(.+):/) {
    $class = $1;
  } elsif (/\s*(.+?)\*?\s*(\(.+?\)\s*)?$/) {
    next unless exists $S{$1};
    if (oneof $class, qw(Abjads Alphabets Alphasyllabaries Syllabaries)
        and not oneof $1, @nospace)  {push @alpha, $1}
    else                             {push @unsup, $1}
    $S{$1} = $class;
    #print "$class $1\n";
  } else {
    die;
  }
}

sub is_target ( $ ) {
  return (length $_[0] == 2
          && (trim @{$L{$_[0]}[2]}, @alpha)
          && !oneof $_[0], @ignr);
}

open F, ">target.txt";

my $target = 0;
foreach my $k  (sort keys %L) {
  next unless is_target $k;
  print F "$k $L{$k}[1]\n";
  $target++;
}

close F;

print "TARGET: $target\n";

foreach (keys %S) {print "ERROR: Unknown class $_\n" unless defined $S{$_};}

sub f ( $ $ @ ) {
  my $i = shift;
  my $name = shift;
  my @inf = map {[@$_, 0, 0]} @_;
  open F, "$name.txt";
  while (<F>) {
    s/\#.*$//;
    next if /^\s*$/;
    my ($l, @d) = split /\s+/;
    die "Unknown lang '$l'" unless $L{$l};
    my $n = 1;
    $n++ while ($n != @inf && $inf[$n][0] ne $d[0]);
    $n = 0 if $n == @inf;
    my $what = $inf[$n][1];
    $inf[$n][2]++;
    $inf[$n][3]++ if is_target $l;
    die "Conflict for '$l'" if $L{$l}[$i] && $L{$l}[$i] ne $what;
    $L{$l}[$i] = $what;
  }
  close F;
  print "$name:\n";
  my $total = 0;
  my $total2 = 0;
  foreach (@inf) {
    $total += $_->[2];
    $total2 += $_->[3];
    printf "  %-12s %3d %3d  %3d  %0.2f\n", $_->[1], $_->[2], $total,
      $total2, $total2 / $target;
  }
}

f 3, "dict", [' ', '0.50'], ['E', '0.60'], 
             ['P', 'Planned'], ['M', 'Maybe'];

f 4, "trans", [' ', 'Yes'], ['I', 'Incomplete'];

while (my ($k, $v) = each %L) {
  $LL{$k} = $L{$k};
  if ((length($k) == 2 && !oneof $k, @ignr) || defined $v->[3] || defined $v->[4]) {
    die "$k has unknown script" unless defined $v->[2];
  } else {
    delete $L{$k};
  }
}

#
#
#

open F, ">dict.lst";
foreach my $k ( sort keys %L) {
  my $d = $L{$k}[3];
  next unless defined $d;
  next unless $d eq '0.50' || $d eq '0.60';
  print F "$k\n";
}
close F;

#
#
#

sub table ( $ @ ) {

  my $file = shift;
  my @which = @_;
  my $path = "/home/kevina/aspell/manual/$file.texi";

  open F, ">$path" or die;

  my @max = ('Code','','','Dictionary', 'Translation');
  my $prev = ' ';
  my $table = '';

  foreach my $k (sort keys %L) {
    my @d = @{$L{$k}};
    my (@s) = trim @{$d[2]}, @which;
    next unless @s;
    $d[2] = join ', ', @s;
    $table .= "\@item\n" if substr($prev,0,1) ne substr($d[0],0,1);
    $table .= "\@item ";
    $table .= "$d[0] \@tab \@tab "       if $prev eq $d[0];
    $table .= "$d[0] \@tab $d[1] \@tab " if $prev ne $d[0];
    $table .= join (" \@tab ", map {length $_ ? $_ : '-'} @d[2,3,4]) . "\n";
    for my $i (0..4) 
      {foreach (split /\s+/, $d[$i]) 
         {$max[$i] = $_ if length $max[$i] < length $_}}
    $prev = $d[0];
  }

  print F '@multitable @columnfractions 0.05 0.31 0.29 0.20 0.15', "\n";
  #join(" ", map {"{${_}}"} @max), "\n";
  print F '@item @b{Code} @tab @b{Language Name} @tab @b{Script} @tab @b{Dictionary Available} @tab @b{Gettext Translation}', "\n";
  print F "$table\n";
  print F "\@end multitable\n";
}

sub table2 ( $ @ ) {

  my $file = shift;
  my @which = @_;
  my $path = "/home/kevina/aspell/manual/$file.texi";

  open F, ">$path" or die;

  my @max = ('Code','Language Name','Script');
  my $prev = ' ';
  my $table = '';

  foreach my $k (sort keys %L) {
    my @d = @{$L{$k}};
    my (@s) = trim @{$d[2]}, @which;
    next unless @s;
    $d[2] = join ', ', @s;
    $table .= "\@item ";
    $table .= "$d[0] \@tab \@tab "       if $prev eq $d[0];
    $table .= "$d[0] \@tab $d[1] \@tab " if $prev ne $d[0];
    $table .= "$d[2]\n";
    for my $i (0 .. 2) {$max[$i] = $d[$i] if length $max[$i] < length $d[$i]}
    $prev = $d[0];
  }

  print F "\@multitable ", join(" ", map {"{${_}}"} @max), "\n";
  print F '@item @b{Code} @tab @b{Language Name} @tab @b{Script}', "\n";
  print F "$table\n";
  print F "\@end multitable\n";
}

table 'lang-supported', @alpha;
table2 'lang-unsupported', @unsup;

open F, ">planned.txt";
foreach my $k (sort keys %L) {
  my @d = @{$L{$k}};
  next unless $d[3] eq 'Planned';
  print F "$d[0] $d[1]\n";
}
close F;

sub otrans ( $ $ ) {
  my $i = shift;
  my $name = shift;

  open F, "$name.txt";

  while (<F>) {
    my ($l, $n) = split /\s+/;
    next if oneof $l, @skip;
    $l = 've' if $l eq 'ven';
    die "Unknown lang '$l'" unless $LL{$l};
    print "Unknown script '$l'\n" unless $LL{$l}[2];
    $LL{$l}[$i] = $n;
  }
}

otrans 5, 'gnome';
otrans 6, 'kde';

open F, ">res.txt";

my @d;

sub table3 (&) {
  printf F "  %-4s %-20s %-25s Gnome  KDE\n\n", qw(Code Language Script);
  my $c = 0;
  foreach my $k (sort keys %LL) {
    @d = @{$LL{$k}};
    next unless defined $d[5] || defined $d[6];
    my (@s) = trim @{$d[2]}, @alpha;
    next unless @s;
    $d[2] = join ', ', @s;
    next unless &{$_[0]};
    $d[5] = '-' unless defined $d[5];
    $d[6] = '-' unless defined $d[6];
    printf F "  %-4s %-20s %-25s   %2s    %2s\n", $d[0], $d[1], $d[2], $d[5], $d[6];
    $c++;
  }
  print F "\n";
  print F "Total: $c\n\n";
}

print F "To Look Into:\n\n";
table3 {!defined $d[3] && ($d[5] >= 15 || $d[6] >= 15)};

print F "Maybe:\n\n";
table3 {!defined $d[3] && !($d[5] >= 15 || $d[6] >= 15)};


print F "Possible Proofreaders:\n\n";
table3 {oneof $d[0], qw(ast ceb ch kw fy haw oc tpi)};
