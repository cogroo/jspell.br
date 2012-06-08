#!/usr/bin/perl

use v5.12;
use strict;
use warnings;

use LWP::Simple;

my $content = get("http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/");

my @max = (0, "");

while ($content =~ /firefox-(\d+\.\d+(?:[a-z]\d+)?)/g) {
    my $v = $1;
    my $decimal = 0;
    my $alfa = "";
    $v =~ /^(\d+\.\d+)(.*)$/ and $decimal = $1 and $alfa = ($2 || "");
    if (($decimal > $max[0]) ||
        ($decimal == $max[0] and $alfa gt $max[1])) {
        @max = ($decimal, $alfa)
    }
}

say @max
