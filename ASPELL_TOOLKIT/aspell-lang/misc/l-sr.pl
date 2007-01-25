
use Data::Dumper;

binmode(STDOUT, ":utf8");

use Unicode::Normalize;

# Latin Extra - 10 - [128,138) 0x80..89
# Laten Accen - 40 - [138,178) 0x8A..B1
#                                      
# Cry Let - 60     - [180,240) 0xB4..EF
# Cry Acc - 40     - [240,256) 0xF0..FF - 24 left
#                  -           0x04..0F and 14..1F

# 1 - 9
# 



sub to_uni ( @ )
{
  map {chr(hex($_))} @_;
}

sub add_lower ( @ )
{
  my @res;
  foreach (@_) {push @res, $_, lc($_)}
  return @res;
}

@c = add_lower to_uni qw(
0410
0411
0412
0413
0414
0402
0415
0416
0417
0418

0408
041A
041B
0409
041C
041D
040A
041E
041F
0420

0421
0422
040B
0423
0424
0425
0426
0427
040F
0428
);

my @l = add_lower to_uni qw(0106 010C 0110 0160 017D);

my @a;
foreach (qw(A E I O U)) {
  foreach my $a (to_uni qw(0300 0301 0302 030F)) {
    push @a, NFC("$_$a"), NFC(lc($_).$a);
  }
}

#my $i = 0;
#foreach (@c,@laten_e) {
#  print "\n" if $i % 10 == 0;
#  print $_, lc($_), " ";
#  $i++;
#}
#print "\n";

$avoid = "\x00\x10\n\r\t\b\e\f\xb2\xb3";

foreach (0..length($avoid)) {
  my $c = substr $avoid, $_, 1;
  $avoid{ord($c)} = 1;
}

foreach (128..255,0..31) {
  push @u, $_ unless $avoid{$_};
}

push @m, map {ord $_} @l;
push @m, map {ord $_} @a;
push @m, map {ord $_} @c;
push @m, 0xE3C0..0xE3E7;

my $d = <<"---";
E3C0 = 0410 0300
E3C1 = 0430 0300
E3C2 = 0410 0301
E3C3 = 0430 0301
E3C4 = 0410 0302
E3C5 = 0430 0302
E3C6 = 0410 030F
E3C7 = 0430 030F
E3C8 = 0415 0300
E3C9 = 0435 0300
E3CA = 0415 0301
E3CB = 0435 0301
E3CC = 0415 0302
E3CD = 0435 0302
E3CE = 0415 030F
E3CF = 0435 030F
E3D0 = 0418 0300
E3D1 = 0438 0300
E3D2 = 0418 0301
E3D3 = 0438 0301
E3D4 = 0418 0302
E3D5 = 0438 0302
E3D6 = 0418 030F
E3D7 = 0438 030F
E3D8 = 041E 0300
E3D9 = 043E 0300
E3DA = 041E 0301
E3DB = 043E 0301
E3DC = 041E 0302
E3DD = 043E 0302
E3DE = 041E 030F
E3DF = 043E 030F
E3E0 = 0423 0300
E3E1 = 0443 0300
E3E2 = 0423 0301
E3E3 = 0443 0301
E3E4 = 0423 0302
E3E5 = 0443 0302
E3E6 = 0423 030F
E3E7 = 0443 030F
---

foreach (split "\n", $d) {
  ($k, $v0, $v1) = /(....) = (....) (....)/ or die;
  $decomp{hex $k} = chr(hex $v0).chr(hex $v1);
}


print "letters ", join(' ', @l), "\n\n";

print "include ascii.txt\n\n";

for ($i = 0; $i < @m; $i++) {
  printf "0x%02X U+%04X # %s\n", $u[$i], $m[$i], 
      ($m[$i] < 0xE000 ? chr($m[$i]) : $decomp{$m[$i]});
}
