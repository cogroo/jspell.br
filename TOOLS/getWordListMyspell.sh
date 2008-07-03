DIC=../MYSPELL/portugues/pt\_PT.dic

cat $DIC | jspell -e -o '' | perl -p -e 's/[,=]//g;s/ +/\n/g' > wl.tmp 
cat wl.tmp | perl -ne 'next if /^\s+$/; print' > wl2.tmp
sort -u wl2.tmp > wordlistMyspell
rm w*tmp
