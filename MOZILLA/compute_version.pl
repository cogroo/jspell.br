#!/usr/bin/perl -s

use warnings;
use strict;

our ($last);

#  0    1    2     3     4    5     6     7     8
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

$mon++;
$year += 1900 - 2000;

my $version = 0;
my $str;

open V, "OOO/versions.txt" or die "$!";
my @versions = <V>;
close V;
chomp @versions;

if ($last) {
    print "$versions[-1]\n";
    exit;
}

do {
    $version++;
    $str = sprintf("%d.%d.%d.%d", $year, $mon, $mday, $version);
} while (grep { $_ eq $str } @versions);

open V, ">>", "OOO/versions.txt" or die "$!";
print V "$str\n";
print "$str\n";
close V;
