#Aspell Makefile for using official aspell Language Toolkit

#make aspell (aspell6,aspell5)
#make install


T=aspell-lang
P=$T/pt_PT
L=pt_PT
DATE=date +%Y%m%d

all:
	make clean
	make aspell

aspell:
	make aspell6
	make aspell5

aspell6:
	make aspellv V=6

aspell5:
	make aspellv V=5

aspellv: aspell-wl
	cd $T; perl pre $L iso-8859-1
	cp Copyright $P
	echo ${DATE}
	perl -pe 'BEGIN{$$D=`${DATE}`;chomp $$D}; s/VERSAO/$$D/;s/ASPELL/aspell${V}/' info > $P/info
	cd $P; perl proc create
	cd $P; ./configure; make

aspell-wl: ../port.dic
#	perl gerarWordList ../port.dic > $L.wl
	echo "teste\npolar\nurso\nxadrez" > $L.wl

dist:
	cp $P; make dist

../port.dic:
	cd ..; make port.dic

install :
	cd $P; make install

clean : 
	rm -rf *~ $T/*~ $P $L.wl
