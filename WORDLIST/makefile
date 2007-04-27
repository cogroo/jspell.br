#Makefile para gerar a lista de palavras do dicionário

L=pt_PT
DATE=`date +%Y%m%d`
D=/home/natura/download/sources/Dictionaries
DS=$(D)/misc/
OLDDATE=`ls -c1 $(D)/jspell |grep -v 'latest' |sed -e 's/\.tar\.gz//' |sed -e 's/\D+//' |sort |tail -n 2 |head -n 1`;

all: wl

wl: ../port.dic
	perl gerarWordList.pl ../port.dic > wordlist.$L-$(DATE).txt

bz2: wl
	tar cfj wordlist.$L-$(DATE).tar.bz2  wordlist.$L-$(DATE).txt

diff: wl
	rm -f *bz2
#Copia a última wordlist do natura
	cp $(D)/misc/wordlist/wordlist.$L-$(OLDDATE).tar.bz2
	tar xfj wordlist.$L-$(OLDDATE).tar.bz2
	diff wordlist.$L-$(OLDDATE).tar.bz2 wordlist.$L-$(DATE).tar.bz2 > rawdiffwordlist.$L-$(DATE).txt

#perl -e '$$D=`date +%Y%m%d`; chomp $$D;eval {`diff oldwl.txt wordlist.$L-$$D.txt > rawdiffwordlist.$L-$$D.txt`}; die $$! if $$@>2;' # ??
	perl verbdiff.pl rawdiffwordlist.$L-$(DATE).txt > verbdiffwordlist.$L-$(DATE).txt
../port.dic:
	cd ..; make port.dic

clean : 
	rm -rf *~ *.txt *bz2
