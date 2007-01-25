
#@maps = (['koi8-r',     'kr'],
#         ['koi8-u',     'ku'],
#         ['cp1251',     'cp'],
#         ['iso-8859-5', 'iso'],
#         ['l-uz',       'uz']);
#$range = sub {0x400 <= hex $_[0] && hex $_[0] <= 0x500};
#my $strip = 'CYRILLIC ';

#@maps = (['viscii', 'v'],
#         ['tcvn3',  't']);
@maps = (['iso-8859-1' , '1'],
         ['iso-8859-2' , '2'],
         ['iso-8859-3' , '3'],
         ['iso-8859-4' , '4'],
         ['iso-8859-9' , '9'],
         ['iso-8859-10' , '10'],
         ['iso-8859-13' , '13'],
         ['iso-8859-14' , '14'],
         ['iso-8859-15' , '15'],
         ['iso-8859-16' , '16'],
         ['cp1250',     , 'c0'],
         ['cp1252',     , 'c2'],
         ['cp1254',     , 'c4'],
         ['cp1257',     , 'c7'],
         ['cp1258',     , 'c8'],
         ['viscii', 'vv'],
         ['tcvn3',  'vt'],
         ['iso-8859-1-u', 'u']
        );
$range = sub {return 1};
$strip = 'LATIN ';

foreach my $i (0..$#maps) {
  open F, "maps/$maps[$i][0].cset";
  while (<F>) {
    my ($uni, $t, $n) = /^.. (....) (.) .+ \# (.+)/ or next;
    next if $t eq '.';
    $name{$uni} = $n;
    $tally{$uni}[$i] = $maps[$i][1];
  }
}

foreach my $uni (sort keys %tally) {
  next unless $range->($uni);
  my $n = $name{$uni};
  $n =~ s/^$strip//;
  printf "$uni %-45.45s ", $n;
  foreach my $i (0 .. $#maps) {
    printf '%-3s', $tally{$uni}[$i];
  }
  print "\n";
}
