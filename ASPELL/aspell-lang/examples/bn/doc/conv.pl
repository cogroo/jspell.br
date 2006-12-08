open IN, "is13194-bn.dat";
<IN>;
<IN>;

for $i (0..255)
{
  $_ = <IN>;
  @d = split/\s+/;
  my $j = $d[0] - 0x900;
  print "$i != $j" if $i != $j && $i != $d[0];
  #printf "0x%02X U+%04X\n", $i, $d[0];
}


# is13194-bn = u-beng
