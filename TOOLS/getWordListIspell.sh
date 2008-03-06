DIC=../ISPELL/portugues/portugues.dic

cat $DIC | jspell -e -o '' | perl -p -e 's/[,=]//g;s/ +/\n/g' > wl.tmp 
cat wl.tmp | perl -ne 'next if /^\s+$/; print' > wl2.tmp
sort -u wl2.tmp > wordlistIspell
rm w*tmp
