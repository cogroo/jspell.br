
# Uses the following files from the UCD:
#   UnicodeData.txt
#   DerivedCoreProperties.txt
#   PropList.txt
#   CompositionExclusions.txt
#   PropertyValueAliases.txt
#   Scripts.txt
# Also requires the files:
#   ethiopic-map.txt
#   ethiopic-names.txt

use warnings;
use strict;

use constant { 
  CHAR => 0, CATEGORY => 1, NAME => 2, TYPE => 3, DISPLAY => 4,
  UPPER => 5, LOWER => 6, TITLE => 7, PLAIN => 8, SCRIPT => 9
};

use constant {false => 0, true => 1};

my @vowels = (
  0x61,0x65,0x69,0x6F,0x75,0xE6,0xF8, # Latin: a e i o u ae o/
  0x131, 0x133, 0x153, # Latin: dotless i, ij, oe
  0x3B1,0x3B5,0x3B7,0x3B9,0x3BF,0x3C5,0x3C9, # Greek vowels
  0x430,0x435,0x438,0x43E,0x443,0x44B,0x44D,0x44E,0x44F # Cyrillic vowels
);

my @alpha = (
  0xAA, 0xBA, 0xB5, # Ordinal Indicators, Micro Sign
  0x2071, 0x207F
);

my @modifier = (
  0x200C, 0x200D
);

my $file_format = <<"---";
Aspell Unicode Data File.
Generated with "Unicode-Proc.pl" from the Unicode Character Database 4.0.0.
Do Not Edit Directly!

<char> <type> <display> <upper> <lower> <title> <plain> <script> # <category> # <name>

<char> is the unicode code point

<type> is one of:
  'D' - a decimal digit
  'H' - hyphen
  'W' - white space
  'A' - a "Alphabetic" code point.  Any character marked as alphabetic
        by the Unicode standard but is not actually part of a word.
        Ie, it will not appear as part of the word in a dictionary
        or if it does it is part of a "special" word such as "1st".
  'M' - a "Modifier", Diacritic, or other symbol that are not considered
        letters but are part of the word in a dictionary.
  'V' - a "Vowel" or "significant" modifier.  For Syllabaries this
        only includes vowel marks and not Vowels which appear by
        them self or at the beginning of a syllable.
  'L' - a "Letter"
  '-' - other
a lowercase letter means I am unsure of the code point's role in a word.

Code points marked as 'A' will generally be removed in a preprocessing
stage.  Code points marked as 'M' will be stored with a word in the
dictionary but will generally be stripped from a word when indexing
it.  This means that these code points should not significantly change
the meaning of a word.  Ie, a word without the modifier or a different
modifier will generally be considered a misspelling and not a separate
word. Symbols which can appear as part of a word but also have other
functions, such as the apostrophe U+0027, should _not_ be tagged with
'M'.  Code points tagged with a 'V' are generally vowels, but can also
include "significant" modifier which generally change the meaning of a
word.  Code points tagged with 'L' are generally considered letters.
The distinction between 'V' and 'L' is not very important.  Code
points tagged with 'V' are stripped from a word when forming a
primitive soundslike equivalent for a word.

<display> Y, N, M

<upper> is the uppercase version of the letter

<lower> is the lowercase version of the letter

<title> is the titlecase version of the letter

<plain> is the "base" form of the letter, ie one without any accents.

<category> is the "General Category" as given in UnicodeData.txt

<name> is the name as given in UnicodeData.txt
---

my @data;

open F, "UnicodeData.txt";
while (<F>) {
  chop;
  my @d = split /;/;
  my $i = hex $d[0];
  next if 0x2100 <= $i && $i <= 0x303F; # Mathematical and other
  next if 0x3200 <= $i && $i <= 0x9FFF; # CJK
  next if 0xAC00 <= $i && $i <= 0xF8FF; # Misc ranges
  next if 0xF900 <= $i && $i <= 0xFAFF; # CJK
  next if 0xFE00 <= $i && $i <= 0xFE0F; # Variation Selectors
  next if 0x10080 <= $i && $i <= 0x100FF; # Linear B Ideograms
  next if 0x1D000 <= $i && $i <= 0x1D7FF; # Mathematical Alphanumeric Symbols
  next if 0x20000 <= $i && $i <= 0x2FA1F; # CJK
  next if 0xE0001 <= $i && $i <= 0xE01FF; # Tags
  next if 0xF0000 <= $i && $i <= 0xFFFFF; # Variation Selectors Supplement
                                          # Private use area
  next if 0x100000 <= $i && $i <= 0x10FFFF; # Private use area
  $data[$i] = \@d;
}

my @final;
my %decomp;

for (my $i = 0; $i < @data; ++$i) {
  next unless $data[$i];
  my @d = @{$data[$i]};
  my $uni = $d[0];
  my $type = $d[2];
  my $comb = $d[3];
  my $display = ($type =~ /^M/   ? 'M'
                 : $type =~ /^C/ ? 'N'
                 : 'Y');
  my $upper = $d[12] || $uni;
  my $lower = $d[13] || $uni;
  my $title = $d[14] || $upper;
  my @decomp = split / /, $d[5];
  my $plain;
  if (@decomp) {
    $decomp{$uni} = $d[5];
    my $tag = shift @decomp if @decomp && $decomp[0] =~ /^</;
    foreach (@decomp) {
      next unless $data[hex $_] && $data[hex $_][2] =~ /^L[^m]/;
      $plain = defined $plain ? '' : $_;
    }
  }
  $plain = $plain || $uni;
  $final[$i] = [$uni, $type, $d[1], undef, $display, $upper, $lower, $title, $plain, 'Zyyy'];
}

foreach (@modifier) {
  $final[$_][TYPE] = 'M';
}

# recursively apply the plain attribute
#for (my $i = 0; $i < @final; ++$i) {
#  my $d = $final[$i];
#  next unless $d;
#  my $a = '';
#  my $b = $d->[CHAR];
#  while ($a ne $b) {$a = $b; $b = $final[hex $b][PLAIN]}
#  $d->[PLAIN] = $a;
#}

my %script;
open F, "PropertyValueAliases.txt";
while (<F>) {
  s/\#(.*)$//;
  s/\s+//g;
  next unless length $_ > 0;
  my ($w, $a, $s) = split ';';
  next unless $w eq 'sc';
  $script{$s} = $a;
}

open F, "Scripts.txt";
while (<F>) {
  s/\#(.*)$//;
  s/\s+//g;
  next unless length $_ > 0;
  my ($r,$s) = split ';';
  my ($x,$y) = $r =~ /^([A-F0-9]+)\.\.([A-F0-9]+)$/;
  $x = $y = $r unless defined $x;
  #print "$x..$y\n";
  for (my $i = hex $x; $i <= hex $y; $i++) {
    $final[$i][SCRIPT] = $script{$s} if defined  $final[$i];
  }
}

open F, "DerivedCoreProperties.txt";
while (<F>) {
  chop;
  s/#.+//; s/^\s+//; s/\s+$//;
  my ($range, $prop) = split / *; */;
  next unless defined $prop && $prop eq "Alphabetic";
  my ($b, $e);
  ($b, $e) = ($1, $1) if $range =~ /^([0-9A-Fa-f]+)$/;
  ($b, $e) = ($1, $2) if $range =~ /^([0-9A-Fa-f]+)\.\.([0-9A-Fa-f]+)$/;
  for (my $i = hex $b; $i <= hex $e; $i++) {
    my $d = $final[$i];
    next unless defined $d;
    next if 0x2100 <= $i && $i <= 0x214F;   # Letterlike symbols
    $d->[TYPE] = (grep {$_ == $i} @alpha) ? 'A' : 'l';
  }
}

open F, "PropList.txt";
while (<F>) {
  chop;
  s/#.+//; s/^\s+//; s/\s+$//;
  my ($range, $prop) = split / *; */;
  next unless defined $prop;
  my ($b, $e);
  ($b, $e) = ($1, $1) if $range =~ /^([0-9A-Fa-f]+)$/;
  ($b, $e) = ($1, $2) if $range =~ /^([0-9A-Fa-f]+)\.\.([0-9A-Fa-f]+)$/;
  for (my $i = hex $b; $i <= hex $e; $i++) {
    my $d = $final[$i];
    next unless defined $d;
    if      ($prop eq 'White_Space') {$d->[TYPE] = 'W';}
    elsif ($prop eq 'Hyphen')      {$d->[TYPE] = 'H';}
    elsif ($prop eq 'Diacritic' &&
           !(0x2100 <= $i && $i <= 0x214F)  && # Letterlike symbols
           (defined $d->[TYPE] || $d->[CATEGORY] =~ /^M[nc]/)) {$d->[TYPE] = 'M';}
  }
}

sub to_stripped($) {
  my $c = hex $final[$_[0]][PLAIN];
  $c = hex $final[$c][PLAIN] while $c != hex $final[$c][PLAIN];
  hex $final[$c][LOWER];
}

for (my $i = 0; $i < @final; ++$i) {
  my $d = $final[$i];
  next unless defined $d;
  next unless defined $d->[TYPE];
  next unless $d->[TYPE] eq 'l';
  if ($d->[CATEGORY] =~ /^L[^m]/ &&
      $d->[NAME] =~ /LETTER|SYLLABLE|SYLLABICS|LIGATURE/) {
    $d->[TYPE] = (grep {$_ == to_stripped $i} @vowels)
      ? 'V' : 'L';
  } elsif ($d->[NAME] =~ /VOWEL SIGN/) {
    $d->[TYPE] = 'V';
  } elsif ($d->[NAME] =~ /GREEK.+SYMBOL/) {
    $d->[TYPE] = 'A';
  }
}

for (my $i = 0; $i < @final; ++$i) {
  my $d = $final[$i];
  next unless defined $d;
  if ($d->[CATEGORY] =~ /^Nd/)   {$d->[TYPE] = 'D'}
  elsif (not defined $d->[TYPE]) {$d->[TYPE] = '-'}
}

sub get_type ( $ ) { if ($final[hex $_[0]])
                       { my $t = uc $final[hex $_[0]][TYPE];
                         $t = 'L' if $t eq 'V';
                         return $t;}
                     else
                       { return '-'}}

while (my ($k, $d) = each %decomp) {
  if ($d !~ /^</) { # canical decomposition
    $decomp{$k} = [$d, '='];
  } else {          # compatibility decomposition
    my @decomp = split / /, $d;
    my $tag = shift @decomp;
    my $T = get_type $k;
    my $use;
    # remove <fraction> <super> and <sub> decompositions
    if ($tag eq '<fraction>' || $tag eq '<super>' || $tag eq '<sub>') {
      $use = false;
    }
    # remove decompositions which will decompose into a space
    #   and combining marks
    elsif (@decomp > 1 &&
           get_type $decomp[0] eq 'W' &&
           ! grep {get_type $decomp[0] eq 'M'} @decomp[1..$#decomp]) {
      $use = false;
    }
    # remove arabic word ligatures
    elsif ($k =~ /^FDF.$/) {
      $use = false;
    }
    # remove decompositions which will convert something that was
    #   not a letter into a letter
    else {
      foreach (@decomp) {
        my $t = get_type $_;
        if (($use || !defined $use) &&
            ($T eq $t || $T eq 'L' || $t ne 'L')) {$use = true}
        else {$use = false}
      }
    }
    if ($use) {$decomp{$k} = [join(' ', @decomp), '!', $tag]}
    else      {delete $decomp{$k}}
  }
}

# for some reason these decompositions are not included in the
# Unicode data file
$decomp{'00C6'} = ['0041 0045', '!', '<compat>']; # AE
$decomp{'00E6'} = ['0061 0065', '!', '<compat>']; # ae
$decomp{'0152'} = ['004F 0045', '!', '<compat>']; # OE
$decomp{'0153'} = ['006F 0065', '!', '<compat>']; # oe

open F, "CompositionExclusions.txt";
while (<F>) {
  chop;
  s/#.*//; s/^\s+//; s/\s+$//;
  next unless $_;
  my ($u) = /^([0-9A-Fa-f]+)$/ or die "??$_.\n";
  next unless exists $decomp{$u};
  $decomp{$u}[1] = '>';
}

&ethiopic;
&serbian;

open T, ">unicode.txt";
open D, ">unicode.dat";

foreach (split "\n", $file_format) {
  print T "# $_\n";
}
print T "#\n\n";

for (my $i = 0; $i < @final; ++$i) {
  next if !$final[$i];
  my $d = $final[$i];
  print T "@$d[CHAR,3..9] # $d->[CATEGORY] # $d->[NAME]\n";
  $d->[TYPE] = '' if $d->[TYPE] eq '-';
  $d->[LOWER] = '' if $d->[LOWER] eq $d->[CHAR];
  $d->[TITLE] = '' if $d->[TITLE] eq $d->[UPPER];
  $d->[UPPER] = '' if $d->[UPPER] eq $d->[CHAR];
  $d->[PLAIN] = '' if $d->[PLAIN] eq $d->[CHAR];
  my $str = join(';',@$d[CHAR,3..9]);
  $str =~ s/;+$//;
  #next if $str =~ /^[0123456789ABCDEF]+;+$/;
  next unless $str =~ /;/;
  print D "$str\n";
}

open T, ">decomp.txt";

foreach my $u (sort {hex $a <=> hex $b} keys %decomp) {
  my @b = [$u, @{$decomp{$u}}];
  # recuressivly decompose in a breadth first fashin
  while (@b) {
    my @a = @b;
    @b = ();
    while (my $d = shift @a) {
      print T "$d->[0] $d->[2] $d->[1]";
      print T " # $d->[3]" if $d->[3];
      print T "\n";
      my @D = split / /, $d->[1];
      for (my $i = 0; $i < @D; $i++) {
        next unless $decomp{$D[$i]};
        my $n = [@$d];
        my @tmp = @D;
        $tmp[$i] = $decomp{$D[$i]}[0];
        $n->[1] = join ' ', @tmp;
        my $f = $d->[2];
        $f = '>' if $f eq '=' && $decomp{$D[$i]}[1] eq '>';
        $f = '!' if ($f eq '=' || $f eq '>') && $decomp{$D[$i]}[1] eq '!';
        $n->[2] = $f;
        push @b, $n;
      }
    }
  }
}

sub ethiopic {
  open ED, "ethiopic-names.txt";
  while (<ED>) {
    my ($c, $n) = /^(E4\w\w) (.+)$/ or die;
    my ($w) = /ETHIOPIC (\w)\w+ PART/ or die;
    $w = 'L' if $w eq 'C';
    $final[hex $c] = [$c, 'Lo', $n, $w, 'N', $c, $c, $c, $c, 'Ethi'];
  }
  open ED, "ethiopic-map.txt";
  my $base = 0xE400;
  while (<ED>) {
    chop;
    s/^(E4\w\w) +// or die;
    my $c = $1;
    my @v = split / +/, $_;
    foreach my $i (0..12) {
      next unless hex $v[$i] != 0;
      my $uni = $v[$i];
      my $v = sprintf "%04X", 0xE430 + $i;
      #print "$c $v = $uni\n";
      $decomp{$uni} = ["$c $v", '='];
    }
  }
}

sub serbian {
  my @upper = (0x410, 0x415, 0x418, 0x41E, 0x423);
  my @accents = (0x0300, 0x0301, 0x0302, 0x030F);
  my $base = 0xE3C0;
  my $i = $base;
  foreach my $c (@upper) {
    foreach my $a (@accents) {
      my $u = sprintf "%04X", $i;
      my $l = sprintf "%04X", $i + 1;
      my ($suf) = $final[$a][NAME] =~ /^COMBINING (.+)/ or die;
      $final[$i]   = [$u, 'Lu', "[$final[$c][NAME] WITH $suf]", 
                      'V', 'N', ,$u, $l, $u, $final[$c][UPPER], 'Cyrl'];
      $final[$i+1] = [$l, 'Ll', "[$final[hex $final[$c][LOWER]][NAME] WITH $suf]",
                      'V', 'N', ,$u, $l, $u, $final[$c][LOWER], 'Cyrl'];
      $decomp{$u} = [sprintf("%s %04X", $final[$c][UPPER], $a), '='];
      $decomp{$l} = [sprintf("%s %04X", $final[$c][LOWER], $a), '='];
      $i += 2;
    }
  }
}
