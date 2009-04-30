#!/usr/bin/perl

use strict;
use warnings;

use Lingua::Jspell;
use Data::Dumper;

$Data::Dumper::Indent = 0;

my $dic = new Lingua::Jspell "Port";
my @words = qw.Europa cavalo grande comido eu dez sexto.;

for $a (@words) {
    print "--( $a )-----------------------\n";
    my @f = $dic->fea($a);
    print Dumper(\@f),"\n";
    @f = $dic->new_featags($a);
    print Dumper(\@f),"\n";
    print "\n";
}
