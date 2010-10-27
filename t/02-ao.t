#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

my @files = <DIC/*.dic>;

for my $file (@files) {
    open F, $file or die;
    while (<F>) {
        if (/AO(.*?)=/) {
            is($1, '90', "$file +$.");
        }
    }
    close F;

    # show progress
    ok(1, $file);
}
