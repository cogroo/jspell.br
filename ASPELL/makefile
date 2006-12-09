#Aspell Makefile for using official aspell Language Toolkit

#make aspell (aspell6,aspell5)
#make install


T=aspell-lang
P=$T/pt_PT
L=pt_PT
DATE=date +%Y%m%d

all:
	make aspell6

aspell6:
	make aspellv V=6

aspell5:
	make aspellv V=5

aspellv: aspell-wl
	cd $T; perl pre $L iso-8859-1
	cp $L.wl $P
	cp Copyright $P
	perl -pe 'BEGIN{$$D=`${DATE}`;chomp $$D}; s/VERSAO/$$D/g;s/ASPELL/aspell${V}/g' info > $P/info
	cd $P; perl proc create; ./configure; #make

aspell-wl: ../port.dic
	rm -rf $P
#	perl gerarWordList ../port.dic > $L.wl
	tail -n 100 ../port.dic > _
	perl gerarWordList _ > $L.wl
	rm _


dist:
	cd $P; make dist

../port.dic:
	cd ..; make port.dic

install :
	cd $P; make install

clean : 
	rm -rf *~ $T/*~ $P $L.wl
