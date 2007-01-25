
open IN, "../unicode.txt";

my ($b,$w) = (0xE400, 0x80);
my $e = $b + $w;
my $base = 0x80;

while (<IN>) {
  my ($uni, $name) = /^(....) .+# .. # (.+)/ or next;
  my $n = hex $uni;
  #print "$b <= $n && $n < $e\n";
  next unless $b <= $n && $n < $e;
  printf "0x%02X 0x$uni # $name\n", ($n - $b) + $base;
}

