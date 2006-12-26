#Makefile para gerar a lista de palavras do dicionário

L=pt_PT
DATE=date +%Y%m%d

all: wl

wl: ../port.dic
	perl gerarWordList.pl ../port.dic > wordlist.$L-`$(DATE)`.txt

bz2: #wl
	tar cfj wordlist.$L-`$(DATE)`.tar.bz2  wordlist.$L-`$(DATE)`.txt

diff: #wl
	rm -f *bz2
	cp `ls -t1r $(OLDWL)/*20*bz2 |tail -n1` oldwl.tar.bz2
	tar xfj oldwl.tar.bz2 -O > oldwl.txt
	diff oldwl.txt wordlist.$L-`$(DATE)`.txt > rawdiffwordlist.$L-`$(DATE)`.txt
	perl verbdiff.pl rawdiffwordlist.$L-`$(DATE)`.txt > verbdiffwordlist.$L-`$(DATE)`.txt
../port.dic:
	cd ..; make port.dic

clean : 
	rm -rf *~ *.txt *bz2
