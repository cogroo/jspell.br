#Makefile para gerar a lista de palavras do dicionário

L=pt_PT
DATE=date +%Y%m%d

all: wl

wl: ../port.dic
	perl gerarWordList.pl ../port.dic > $L.wl

bz2: #wl
	tar cfj wordlist.$L-`$(DATE)`.tar.bz2 $L.wl

../port.dic:
	cd ..; make port.dic

clean : 
	rm -rf *~ $L.wl *bz2
