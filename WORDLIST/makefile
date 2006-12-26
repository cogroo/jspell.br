#Makefile para gerar a lista de palavras do dicionário

L=pt_PT
DATE=date +%Y%m%d

all: wl

wl: ../port.dic
	perl gerarWordList.pl ../port.dic > wordlist.$L-`$(DATE)`.txt

bz2: #wl
	tar cfj wordlist.$L-`$(DATE)`.tar.bz2  wordlist.$L-`$DATE`.txt

diff: wl
	rm *bz2
	cp $(OLDWL)/`ls -t1r $(OLDWL)/*20*bz2 |tail -n1` .
	tar xfj `ls -t1 *20*bz2 |tail -n1`
../port.dic:
	cd ..; make port.dic

clean : 
	rm -rf *~ *.txt *bz2
