#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

my @files = <DIC/*.dic>;

for my $file (@files) {
    my $last = 0;
    open F, $file or die;
    while (<F>) {
        if (/\n$/) {
            $last = 1;
        } else {
            $last = 0;
        }
    }
    close F;
    ok($last, $file);
}
