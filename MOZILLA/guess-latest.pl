#!/usr/bin/perl

use v5.12;
use strict;
use warnings;

use LWP::Simple;

my $content = get("http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/");

my $max = 3;

while ($content =~ /firefox-(\d+\.\d+(?:[a-z]\d+)?)/g) {
    my $v = $1;
    my $decimal = 0;
    $v =~ /^(\d+)/ and $decimal = $1;
    $max = $decimal if $decimal > $max;
}

say "$max.*"
